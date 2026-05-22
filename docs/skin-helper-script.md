# Skin Helper Script (script.skin.madnox)

## Overview

`script.skin.madnox` is a Python addon (v1.0.6) that provides background logic, script routing, and enhanced functionality for the Madnox skin. It was introduced in the Omega version to consolidate all free-running scripts and satisfy Kodi's addon submission requirements.

- **Entry point:** `default.py`
- **Extension:** `xbmc.python.script`
- **License:** GPL-2.0-or-later
- **Dependency:** `xbmc.python` >= 3.0.0

## Architecture

The script uses a single router pattern. `default.py` parses the `action=` parameter from `sys.argv` and dispatches to the corresponding module in `resources/lib/`.

```
RunScript(script.skin.madnox, action=<action_name>, <additional_params>)
```

The skin XML files invoke the helper via `RunScript()` builtins, passing action names and parameters as needed.

## Actions Reference

### Media Playback

| Action | Module | Description |
|---|---|---|
| `play_trailer` | `play_trailer.py` | Plays a specific trailer by URL or path |
| `trailer_rolling` | `trailer_rolling.py` | Auto-plays trailer previews when hovering over movies in library views |
| `play_album_songs` | `play_album_songs.py` | Queues and plays all songs from a selected album |
| `play_all_music_videos` | `play_all_music_videos_from_container.py` | Plays all music videos from the current container |

### Navigation

| Action | Module | Description |
|---|---|---|
| `decrement_movie` | `script_decrement_movie.py` | Navigates between movie info pages (previous/next) |
| `decrement_person` | `script_decrement_person.py` | Navigates between person info pages |
| `smsjump` | `jump_to_letter.py` | SMS-style jump-to-letter navigation (replaces Embuary Helper) |

### Skin Settings & Configuration

| Action | Module | Description |
|---|---|---|
| `apply_template` | `apply_template.py` | Applies default settings on first run or factory reset |
| `manage_presets` | `preset_manager.py` | Save/load/export/import skin setting presets |
| `write_setting` | `tmdb_helper_settingswriter.py` | Writes TMDb Helper addon settings programmatically |
| `migrate_bgs` | `migrate_bgs.py` | Migrates background settings between format versions |
| `collection_view_sync` | `collection_view_sync.py` | Synchronizes view settings across movie collections |

### Visual & UI

| Action | Module | Description |
|---|---|---|
| `show_color_loader` | `color_loader.py` | Loads saved color configurations |
| `core_color_helper` | `core_color_helper.py` | Powers the custom RGBA color picker dialog |
| `set_intro_label` | `set_intro_label.py` | Sets the display label for the selected intro video |
| `intro_preview` | `intro_preview.py` | Previews startup intro videos in settings |
| `process_ratings` | `process_ratings.py` | Processes and formats rating displays for media items |

### Addon Integration

| Action | Module | Description |
|---|---|---|
| `validate_tmdb_helper` | `tmdb_installed_validation.py` | Checks that TMDb Helper is installed and enabled |
| `install_extras` | `install_extras.py` | Prompts to download optional image resource packs |
| `madnox_cinema` | `madnox_cinema.py` | Full cinema mode experience (see [cinema-mode.md](cinema-mode.md)) |

---

## Key Module Details

### trailer_rolling.py

Automatically plays trailer previews when the user hovers over a movie in library views.

**Behavior:**
1. Detects which view is currently active (supports 30+ view IDs)
2. Monitors cursor position for stabilization (1.6 seconds of no movement)
3. Plays the trailer in the background using a low-priority player
4. Stops immediately when:
   - The info dialog opens
   - The user navigates away
   - The view loses focus
   - A different item is selected
5. Only stops its own trailer playback (does not interrupt user-initiated playback)

**Implementation:** Uses a singleton pattern with a monitor loop running on a background thread.

### apply_template.py

Handles first-run initialization and factory reset.

**Behavior:**
1. Checks if `Madnox.Settings.Initialized` skin setting exists
2. If not set (first run), reads `settings_template.xml`
3. Applies all default settings (booleans, strings, integers) via Kodi builtins
4. Sets the initialized flag to prevent re-running

Also serves as the factory reset mechanism when triggered from skin settings.

### jump_to_letter.py

Native replacement for `script.embuary.helper`'s SMS jump functionality.

**Behavior:**
- Maps letters A-Z to SMS-style key groups (ABC=2, DEF=3, GHI=4, etc.)
- Uses Kodi's JSON-RPC `Input.ExecuteAction` to navigate
- Numbers/# jump to first or last page depending on current sort order
- Supports rapid multi-press to cycle through letters in a group

### preset_manager.py

Full WindowXMLDialog-based UI for managing skin configurations.

**Features:**
- **Save** — Captures current skin settings with timestamped filename
- **Load** — Restores a saved preset (overwrites current settings, reloads skin)
- **Import** — Loads external settings XML files with validation
- **Export** — Saves current settings to any user-specified location
- **Rename** — Renames individual presets
- **Delete** — Removes presets (single or all with confirmation)

### core_color_helper.py

Powers the custom RGBA color picker dialog (`Custom_1104_DialogOverlayColorPicker.xml`).

**Features:**
- Per-channel (R, G, B, A) slider adjustment
- Real-time preview of selected color
- Hex value input/output
- Integration with skin color settings for persistent storage

---

## Home Screen Initialization Sequence

When the Home screen loads for the first time in a session, the helper runs several initialization scripts in sequence (controlled by `Madnox.HomeInitDone` window property):

| Order | Delay | Action | Purpose |
|---|---|---|---|
| 1 | 3s | `apply_template` | First-run settings initialization |
| 2 | — | `migrate_bgs` | Background settings migration |
| 3 | — | Skin Shortcuts XML build | Menu structure generation |
| 4 | 4s | `validate_tmdb_helper` | TMDb Helper enablement check |
| 5 | 5s | `install_extras` | Optional image resource download prompt |

The `Madnox.HomeInitDone` property prevents these from re-firing on subsequent Home screen visits within the same session.

---

## Invoking from Skin XML

The helper is called from skin XML files using Kodi's `RunScript` builtin:

```xml
<!-- Simple action -->
<onclick>RunScript(script.skin.madnox, action=smsjump)</onclick>

<!-- Action with parameters -->
<onclick>RunScript(script.skin.madnox, action=play_trailer, url=$INFO[ListItem.Trailer])</onclick>

<!-- Conditional execution -->
<onclick condition="Skin.HasSetting(TrailerRolling.Enabled)">
    RunScript(script.skin.madnox, action=trailer_rolling)
</onclick>
```
