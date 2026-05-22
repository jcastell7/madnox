#!/bin/bash
#
# deploy.sh — Version bump, repo generation, and git push for Madnox
#
# Usage:
#   ./deploy.sh                     # Interactive mode (prompts for everything)
#   ./deploy.sh skin                # Bump skin only
#   ./deploy.sh script              # Bump script only
#   ./deploy.sh both                # Bump skin + script
#   ./deploy.sh repo                # Bump repository addon only
#   ./deploy.sh all                 # Bump skin + script + repo
#   ./deploy.sh --no-push           # Skip git push at the end
#

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
KODI_FOLDER="piers"
SKIN_ADDON_XML="$REPO_ROOT/$KODI_FOLDER/skin.madnox/addon.xml"
SCRIPT_ADDON_XML="$REPO_ROOT/$KODI_FOLDER/script.skin.madnox/addon.xml"
OMEGA_SKIN_ADDON_XML="$REPO_ROOT/omega/skin.madnox/addon.xml"
OMEGA_SCRIPT_ADDON_XML="$REPO_ROOT/omega/script.skin.madnox/addon.xml"
REPO_ADDON_XML="$REPO_ROOT/repo/repository.madnox/addon.xml"
INDEX_HTML="$REPO_ROOT/index.html"
REPO_GENERATOR="$REPO_ROOT/_repo_generator_v3.py"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}$1${NC}"; }
ok()    { echo -e "${GREEN}$1${NC}"; }
warn()  { echo -e "${YELLOW}$1${NC}"; }
error() { echo -e "${RED}$1${NC}" >&2; }

# --- Version helpers ---

get_skin_version() {
    sed -n 's/.*id="skin\.madnox" version="\([^"]*\)".*/\1/p' "$SKIN_ADDON_XML"
}

get_script_version() {
    sed -n '/^<addon/,/<\/addon>/s/.*version="\([^"]*\)".*/\1/p' "$SCRIPT_ADDON_XML" | head -1
}

get_omega_skin_version() {
    sed -n 's/.*id="skin\.madnox" version="\([^"]*\)".*/\1/p' "$OMEGA_SKIN_ADDON_XML"
}

get_omega_script_version() {
    sed -n '/^<addon/,/<\/addon>/s/.*version="\([^"]*\)".*/\1/p' "$OMEGA_SCRIPT_ADDON_XML" | head -1
}

set_omega_skin_version() {
    local new_version="$1"
    sed -i '' "s/\(id=\"skin\.madnox\" version=\"\)[^\"]*/\1${new_version}/" "$OMEGA_SKIN_ADDON_XML"
}

set_omega_script_version() {
    local new_version="$1"
    sed -i '' "s/^       version=\"[^\"]*\"/       version=\"${new_version}\"/" "$OMEGA_SCRIPT_ADDON_XML"
}

update_omega_skin_script_dependency() {
    local new_version="$1"
    sed -i '' "s/\(import addon=\"script\.skin\.madnox\" version=\"\)[^\"]*/\1${new_version}/" "$OMEGA_SKIN_ADDON_XML"
}

bump_skin_version() {
    local current="$1"
    local today
    today=$(date +"%y.%m.%d")

    if [[ "$current" == "$today" ]]; then
        # Same day release — append/increment a suffix
        # e.g. 25.05.22 -> 25.05.22.1, 25.05.22.1 -> 25.05.22.2
        echo "${today}.1"
    elif [[ "$current" == "$today".* ]]; then
        local suffix="${current##*.}"
        echo "${today}.$((suffix + 1))"
    else
        echo "$today"
    fi
}

bump_script_version() {
    local current="$1"
    local major minor patch
    IFS='.' read -r major minor patch <<< "$current"
    echo "${major}.${minor}.$((patch + 1))"
}

get_repo_version() {
    sed -n 's/.*id="repository\.madnox"[^>]*version="\([^"]*\)".*/\1/p' "$REPO_ADDON_XML"
}

bump_repo_version() {
    local current="$1"
    local major minor patch
    IFS='.' read -r major minor patch <<< "$current"
    echo "${major}.${minor}.$((patch + 1))"
}

set_repo_version() {
    local new_version="$1"
    sed -i '' "s/\(id=\"repository\.madnox\"[^>]*version=\"\)[^\"]*/\1${new_version}/" "$REPO_ADDON_XML"
}

update_repo_artifacts() {
    local old_version="$1"
    local new_version="$2"
    local old_zip="repository.madnox-${old_version}.zip"
    local new_zip="repository.madnox-${new_version}.zip"

    # Copy new zip from generated zips to repo root
    if [[ -f "$REPO_ROOT/repo/zips/repository.madnox/${new_zip}" ]]; then
        cp "$REPO_ROOT/repo/zips/repository.madnox/${new_zip}" "$REPO_ROOT/${new_zip}"
        ok "  Copied ${new_zip} to repo root"
    fi

    # Remove old root zip if different
    if [[ "$old_zip" != "$new_zip" && -f "$REPO_ROOT/${old_zip}" ]]; then
        rm "$REPO_ROOT/${old_zip}"
        ok "  Removed old ${old_zip}"
    fi

    # Update index.html
    sed -i '' "s/${old_zip}/${new_zip}/g" "$INDEX_HTML"
    ok "  Updated index.html -> ${new_zip}"
}

set_skin_version() {
    local new_version="$1"
    sed -i '' "s/\(id=\"skin\.madnox\" version=\"\)[^\"]*/\1${new_version}/" "$SKIN_ADDON_XML"
}

set_script_version() {
    local new_version="$1"
    # Match the indented version line (not the xml declaration version)
    sed -i '' "s/^       version=\"[^\"]*\"/       version=\"${new_version}\"/" "$SCRIPT_ADDON_XML"
}

update_skin_script_dependency() {
    local new_version="$1"
    sed -i '' "s/\(import addon=\"script\.skin\.madnox\" version=\"\)[^\"]*/\1${new_version}/" "$SKIN_ADDON_XML"
}

# --- Main ---

cd "$REPO_ROOT"

# Parse args
BUMP_TARGET=""
NO_PUSH=false

for arg in "$@"; do
    case "$arg" in
        skin|script|both|repo|all) BUMP_TARGET="$arg" ;;
        --no-push) NO_PUSH=true ;;
        -h|--help)
            echo "Usage: ./deploy.sh [skin|script|both] [--no-push]"
            exit 0
            ;;
        *) error "Unknown argument: $arg"; exit 1 ;;
    esac
done

# Interactive mode if no target specified
if [[ -z "$BUMP_TARGET" ]]; then
    echo ""
    info "What do you want to bump?"
    echo "  1) skin        — skin.madnox only"
    echo "  2) script      — script.skin.madnox only"
    echo "  3) both        — skin + script"
    echo "  4) repo        — repository.madnox only"
    echo "  5) all         — skin + script + repo"
    echo ""
    read -rp "Choice [1/2/3/4/5]: " choice
    case "$choice" in
        1|skin)   BUMP_TARGET="skin" ;;
        2|script) BUMP_TARGET="script" ;;
        3|both)   BUMP_TARGET="both" ;;
        4|repo)   BUMP_TARGET="repo" ;;
        5|all)    BUMP_TARGET="all" ;;
        *) error "Invalid choice."; exit 1 ;;
    esac
fi

echo ""
info "=== Madnox Deploy ==="
echo ""

# Check for uncommitted changes unrelated to our work
if ! git diff --quiet HEAD 2>/dev/null; then
    warn "You have uncommitted changes. They will be included in the deploy commit."
    echo ""
    git status --short
    echo ""
    read -rp "Continue? [y/N]: " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || exit 0
fi

# --- Version Bump ---

SKIN_BUMPED=false
SCRIPT_BUMPED=false
REPO_BUMPED=false

if [[ "$BUMP_TARGET" == "skin" || "$BUMP_TARGET" == "both" || "$BUMP_TARGET" == "all" ]]; then
    CURRENT_SKIN=$(get_skin_version)
    NEW_SKIN=$(bump_skin_version "$CURRENT_SKIN")

    info "Skin: $CURRENT_SKIN -> $NEW_SKIN"
    read -rp "Accept new skin version? [Y/n/custom]: " response
    case "$response" in
        ""|[Yy]*) ;; # accept
        [Nn]*) error "Aborted."; exit 0 ;;
        *) NEW_SKIN="$response" ;;
    esac

    set_skin_version "$NEW_SKIN"
    set_omega_skin_version "$NEW_SKIN"
    SKIN_BUMPED=true
    ok "  Skin version set to $NEW_SKIN (piers + omega)"
fi

if [[ "$BUMP_TARGET" == "script" || "$BUMP_TARGET" == "both" || "$BUMP_TARGET" == "all" ]]; then
    CURRENT_SCRIPT=$(get_script_version)
    NEW_SCRIPT=$(bump_script_version "$CURRENT_SCRIPT")

    info "Script: $CURRENT_SCRIPT -> $NEW_SCRIPT"
    read -rp "Accept new script version? [Y/n/custom]: " response
    case "$response" in
        ""|[Yy]*) ;; # accept
        [Nn]*) error "Aborted."; exit 0 ;;
        *) NEW_SCRIPT="$response" ;;
    esac

    set_script_version "$NEW_SCRIPT"
    set_omega_script_version "$NEW_SCRIPT"
    SCRIPT_BUMPED=true
    ok "  Script version set to $NEW_SCRIPT (piers + omega)"

    # Update the skin's dependency on the script
    if [[ "$BUMP_TARGET" == "both" || "$BUMP_TARGET" == "all" ]]; then
        update_skin_script_dependency "$NEW_SCRIPT"
        update_omega_skin_script_dependency "$NEW_SCRIPT"
        ok "  Skin dependency on script.skin.madnox updated to $NEW_SCRIPT (piers + omega)"
    fi
fi

if [[ "$BUMP_TARGET" == "repo" || "$BUMP_TARGET" == "all" ]]; then
    CURRENT_REPO=$(get_repo_version)
    NEW_REPO=$(bump_repo_version "$CURRENT_REPO")

    info "Repo: $CURRENT_REPO -> $NEW_REPO"
    read -rp "Accept new repo version? [Y/n/custom]: " response
    case "$response" in
        ""|[Yy]*) ;; # accept
        [Nn]*) error "Aborted."; exit 0 ;;
        *) NEW_REPO="$response" ;;
    esac

    set_repo_version "$NEW_REPO"
    REPO_BUMPED=true
    ok "  Repo version set to $NEW_REPO"
fi

echo ""

# --- Repo Generation ---

info "Running repo generator..."
echo ""

# Run in non-interactive mode by piping "all" choice to force zip rebuild
printf 'a\n\n' | python3 "$REPO_GENERATOR"

echo ""
ok "Repo generation complete."
echo ""

# --- Post-generation: update repo artifacts ---

if [[ "$REPO_BUMPED" == true ]]; then
    update_repo_artifacts "$CURRENT_REPO" "$NEW_REPO"
fi

# --- Git Operations ---

info "Staging changes..."

# Stage the source addon folders that were bumped
if [[ "$SKIN_BUMPED" == true ]]; then
    git add "$KODI_FOLDER/skin.madnox/"
    git add "omega/skin.madnox/"
fi
if [[ "$SCRIPT_BUMPED" == true ]]; then
    git add "$KODI_FOLDER/script.skin.madnox/"
    git add "omega/script.skin.madnox/"
fi
if [[ "$REPO_BUMPED" == true ]]; then
    git add "repo/"
    git add "index.html"
    git add "repository.madnox-"*.zip
    # Remove old root zip from git if it was deleted
    if [[ "$CURRENT_REPO" != "$NEW_REPO" ]]; then
        git rm --ignore-unmatch -q "repository.madnox-${CURRENT_REPO}.zip" 2>/dev/null || true
    fi
fi

# Stage the regenerated zips
git add "$KODI_FOLDER/zips/"
git add "omega/zips/"

# Build commit message
COMMIT_PARTS=()
if [[ "$SKIN_BUMPED" == true ]]; then
    COMMIT_PARTS+=("skin $NEW_SKIN")
fi
if [[ "$SCRIPT_BUMPED" == true ]]; then
    COMMIT_PARTS+=("script $NEW_SCRIPT")
fi
if [[ "$REPO_BUMPED" == true ]]; then
    COMMIT_PARTS+=("repo $NEW_REPO")
fi
VERSION_SUMMARY=$(IFS=', '; echo "${COMMIT_PARTS[*]}")

echo ""
read -rp "Commit message [Update $VERSION_SUMMARY]: " custom_msg
if [[ -z "$custom_msg" ]]; then
    COMMIT_MSG="Update $VERSION_SUMMARY"
else
    COMMIT_MSG="$custom_msg"
fi

git commit -m "$COMMIT_MSG"
ok "Committed: $COMMIT_MSG"

# Push
if [[ "$NO_PUSH" == true ]]; then
    warn "Skipping push (--no-push flag)."
else
    echo ""
    read -rp "Push to remote? [Y/n]: " push_confirm
    if [[ "$push_confirm" =~ ^[Nn]$ ]]; then
        warn "Skipped push. Run 'git push' when ready."
    else
        git push
        ok "Pushed to remote."
    fi
fi

echo ""
ok "=== Deploy complete ==="
