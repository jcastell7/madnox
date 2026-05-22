# Deployment Guide

How to update skins and addons in the repository and deploy them to Kodi users.

---

## Overview

The update flow is:

1. Make changes to addon source files (e.g. `piers/skin.madnox/`)
2. Bump the version number in the addon's `addon.xml`
3. Run the repo generator script to package zips and update manifests
4. Commit and push to GitHub
5. Kodi users receive the update automatically via the repository

---

## Step 1: Make Your Changes

Edit files in the appropriate version folder:

| Kodi Version | Folder |
|---|---|
| Piers (v21.9.1+, latest) | `piers/` |
| Omega (v21.0.0 - 21.9.0) | `omega/` |
| Nexus (v20.x, legacy) | `nexus/` |

Each folder contains the full source of every addon distributed for that Kodi version.

---

## Step 2: Bump the Version Number

Open the addon's `addon.xml` and increment the `version` attribute:

```xml
<!-- Before -->
<addon id="skin.madnox" version="22.10.08" ...>

<!-- After -->
<addon id="skin.madnox" version="22.10.09" ...>
```

The repo generator detects updates by comparing the version in source `addon.xml` against the version in the existing `zips/addons.xml` manifest. If the version hasn't changed, the addon won't be repackaged (unless you use "build all" mode).

**Version format:** The skin uses `YY.MM.DD` (e.g. `22.10.08`). The helper script uses semver (e.g. `1.0.6`). Follow whatever convention the addon already uses.

**Dependency versions:** If your skin update requires a newer version of `script.skin.madnox` or another dependency, update the `<import>` version in the skin's `addon.xml` as well:

```xml
<import addon="script.skin.madnox" version="1.0.6" />
```

---

## Step 3: Run the Repo Generator

From the repository root:

```bash
python3 _repo_generator_v3.py
```

The script will prompt you to choose a build mode:

| Mode | When to use |
|---|---|
| `changed` (c) | Normal workflow — only repackages addons with version changes |
| `all` (a) | Full rebuild — repackages everything, useful after structural changes |

**What it does:**
1. Scans each version folder (`piers/`, `omega/`, `nexus/`, `repo/`) for addon directories containing `addon.xml`
2. Compares source versions against existing zips
3. Creates new `.zip` packages in `<folder>/zips/<addon-id>/`
4. Copies `addon.xml` and artwork into the zips folder
5. Regenerates `<folder>/zips/addons.xml` (the master manifest)
6. Regenerates `<folder>/zips/addons.xml.md5` (cache-busting checksum)

**Example output:**
```
Processing release folder: piers
Found update for: skin.madnox (22.10.08 -> 22.10.09)
Zip created for skin.madnox (22.10.09) - 4.2 MB
  -- MD5 hash created for skin.madnox-22.10.09.zip
Successfully generated piers/zips/addons.xml
Successfully generated piers/zips/addons.xml.md5
```

---

## Step 4: Commit and Push

Stage the changed source files and the regenerated zips:

```bash
git add piers/skin.madnox/
git add piers/zips/skin.madnox/
git add piers/zips/addons.xml
git add piers/zips/addons.xml.md5
git commit -m "Skin update to 22.10.09 - description of changes"
git push
```

Only stage the specific addon folders you changed. Avoid `git add .` to prevent accidentally committing unrelated files.

---

## Step 5: Users Receive the Update

Once pushed to GitHub:

1. Kodi periodically checks `addons.xml` from the repository URL
2. The repository addon routes users to the correct version folder based on their Kodi version (via `minversion`/`maxversion` in `repo/repository.madnox/addon.xml`)
3. Kodi compares installed addon versions against the manifest
4. If a newer version exists, Kodi downloads and installs the updated zip automatically

Users see an update notification in Kodi. No manual action required on their end.

---

## Updating the Repository Addon Itself

The repository addon (`repo/repository.madnox/`) is special — it's the bootstrap that users install first.

To update it:

1. Edit `repo/repository.madnox/addon.xml` (bump version, update `<dir>` entries if needed)
2. Run the repo generator (it processes the `repo/` folder too)
3. Copy the new zip to the repository root for direct download:
   ```bash
   cp repo/zips/repository.madnox/repository.madnox-<version>.zip ./repository.madnox-<version>.zip
   ```
4. Update `index.html` to point to the new zip filename
5. Commit and push

**When to update the repo addon:**
- Adding support for a new Kodi version (new `<dir>` block)
- Changing the repository URL structure
- Updating repository metadata (description, icon)

---

## Updating Multiple Addons at Once

If a skin update also requires a helper script update:

1. Make changes in both `piers/skin.madnox/` and `piers/script.skin.madnox/`
2. Bump versions in both `addon.xml` files
3. Update the skin's `<import>` to require the new script version
4. Run the repo generator once — it handles all addons in a single pass
5. Commit everything together so users get both updates atomically

---

## Addons in the Repository

### Piers (current)

| Addon | Description |
|---|---|
| `skin.madnox` | The skin itself |
| `script.skin.madnox` | Skin helper script (Python utilities) |
| `resource.images.skin.madnox` | Bundled image resources |
| `resource.images.moviegenreicons.filmstrip-hd.bw` | Genre icons (B&W) |
| `resource.images.moviegenreicons.filmstrip-hd.colour` | Genre icons (color) |
| `plugin.video.themoviedb.helper` | TMDb integration |
| `script.artwork.dump` | Artwork caching |
| `script.preshowexperience` | PreShow Experience |
| `script.wikipedia` | Wikipedia info |
| `service.tvtunes` | TV theme music |
| `repository.jurialmunkey` | Jurialmunkey repo (TMDb dependency) |
| `script.module.infotagger` | Info tagger module |
| `script.module.jurialmunkey` | Jurialmunkey module |
| `script.module.pil` | PIL module |

---

## Testing Before Deployment

Before running the repo generator and pushing:

1. **Local testing in Kodi:** Copy the modified addon folder directly into Kodi's addon directory to test without going through the repository:
   ```bash
   # macOS
   cp -r piers/skin.madnox/ ~/Library/Application\ Support/Kodi/addons/skin.madnox/

   # Linux
   cp -r piers/skin.madnox/ ~/.kodi/addons/skin.madnox/
   ```
   Restart Kodi (or reload the skin via Settings > Interface > Skin) to pick up changes.

2. **Verify XML validity:** Check for syntax errors before packaging:
   ```bash
   xmllint --noout piers/skin.madnox/16x9/*.xml
   ```

3. **Check the testing checklist:** See `docs/testing-checklist.md` for feature-specific test procedures.

---

## Troubleshooting

| Problem | Cause | Fix |
|---|---|---|
| Repo generator says "No addon changes detected" | Version wasn't bumped | Increment version in `addon.xml` |
| Kodi doesn't show the update | `addons.xml.md5` is stale or not pushed | Re-run generator, verify both `addons.xml` and `.md5` are committed |
| Addon installs but skin looks broken | Missing texture/font/include reference | Check Kodi log (`~/.kodi/temp/kodi.log`) for XML parse errors |
| Dependency error on install | Skin requires newer version of a dependency | Update the dependency addon in the same version folder and bump its version |
| Update only appears for some users | Wrong version folder updated | Ensure changes are in the correct folder for the target Kodi version |
