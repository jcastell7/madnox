# Features

## Overview

Madnox is a highly customizable Kodi skin focused on visual appeal and media presentation. This document covers the main features beyond the cinema mode (documented separately in [cinema-mode.md](cinema-mode.md)).

---

## Trailer Rolling

Automatically plays trailer previews when browsing movies in library views.

**How it works:**
1. User navigates to a movie in any supported view (30+ view IDs supported)
2. After 1.6 seconds of cursor stability (no navigation), the trailer begins playing
3. The trailer plays in the background without leaving the current view
4. Playback stops immediately when the user:
   - Opens the info dialog
   - Navigates to a different item
   - Leaves the view or window
   - Starts their own playback

**Key design decisions:**
- Uses a singleton pattern to prevent multiple instances
- Only stops its own trailer playback — never interrupts user-initiated playback
- Monitors via background thread to avoid blocking the UI
- Trailer source comes from the item's `ListItem.Trailer` property (typically a TMDb URL via TMDb Helper)

**Enable/disable:** Controlled via a skin setting toggle.

---

## Preset Manager

A full dialog-based UI for saving, loading, and sharing skin configurations.

**Capabilities:**

| Action | Description |
|---|---|
| Save | Captures all current skin settings with an auto-generated timestamped filename |
| Load | Restores a previously saved preset (overwrites current settings, triggers skin reload) |
| Import | Loads an external settings XML file from any location, with validation |
| Export | Saves current settings to a user-chosen location for sharing |
| Rename | Renames individual preset files |
| Delete | Removes a single preset or all presets (with confirmation) |

**Storage:** Presets are saved as XML files in the skin's userdata directory. Each preset contains the complete set of skin boolean, string, and integer settings.

**Use cases:**
- Quickly switch between different visual configurations
- Share configurations with other users
- Back up settings before experimenting
- Factory reset and restore

---

## Custom Color Picker

A skin-native RGBA color picker that replaces Kodi's limited built-in color dialog.

**Features:**
- Individual R, G, B, A channel sliders
- Real-time color preview
- Hex value input and output
- Persistent storage in skin settings
- Used for customizing: panel colors, text colors, highlight colors, background tints

**Implementation:** The dialog is defined in `Custom_1104_DialogOverlayColorPicker.xml` and powered by `core_color_helper.py` in the helper script.

---

## Jump-to-Letter (SMS Jump)

Native alphabetical navigation that replaces the external `script.embuary.helper` dependency.

**How it works:**
- Maps the alphabet to SMS-style key groups:
  - 2 = ABC, 3 = DEF, 4 = GHI, 5 = JKL, 6 = MNO, 7 = PQRS, 8 = TUV, 9 = WXYZ
- Rapid multi-press cycles through letters within a group
- Uses Kodi's JSON-RPC `Input.ExecuteAction` for navigation
- Numbers/# jump to first or last page depending on sort order

**Advantage over Embuary Helper:** No external dependency required, faster execution, maintained as part of the skin project.

---

## Home Screen Widgets

The home screen supports up to 20 configurable widgets in two layout modes:

| Mode | Description |
|---|---|
| **Carousel** | Horizontal scrolling widget rows |
| **Grid** | Grid-based widget layout |

Widgets are configured through Skin Shortcuts and can display:
- Recently added movies/TV shows/music
- In-progress media
- TMDb lists (trending, popular, now playing)
- Custom playlists
- Favourites
- PVR channels

---

## System Dashboard

A set of system information widgets accessible from the home screen:

| Widget ID | Content |
|---|---|
| 1121 | CPU usage and temperature |
| 1122 | Memory usage |
| 1123 | Storage space |
| 1124 | Network status |
| 1125 | System uptime |
| 1126 | Battery status |
| 1127 | Video playback info |
| 1128 | PVR status |
| 1129 | Kodi version info |

Each widget is a custom dialog (`Custom_1121-1129_*.xml`) that can be toggled on/off.

---

## Media Flags

Visual badges showing codec, resolution, and quality information for media items.

**Display modes:**
- Color — Full color codec/format icons
- Greyscale — Monochrome variant for subtler presentation

**Supported flags:**
- Video codecs (H.264, H.265/HEVC, VP9, AV1, etc.)
- Audio codecs (Dolby Atmos, TrueHD, DTS-X, DTS-HD MA, etc.)
- Resolution (720p, 1080p, 4K UHD)
- HDR formats (HDR10, Dolby Vision, HLG)
- Audio channels (2.0, 5.1, 7.1)

**Codec flag override:** Users can manually select which codec flag to display via a picker dialog (`Custom_1105_DialogVideoCodecFlagPicker.xml`), useful when automatic detection doesn't match the actual source.

---

## Startup Intro Videos

The skin supports playing a video intro when Kodi starts.

**Features:**
- Select from available intro videos
- Preview intros from skin settings before committing
- Set display label for the selected intro
- Skip intro on subsequent launches (configurable)

**Implementation:** `Startup.xml` handles playback, with `intro_preview.py` and `set_intro_label.py` managing the settings UI.

---

## TMDb Helper Integration

Deep integration with `plugin.video.themoviedb.helper` for rich metadata:

**Capabilities:**
- Extended movie/TV show info dialogs with TMDb data
- Cast and crew browsing with person info pages
- Online trailer playback
- Artwork sourcing (posters, fanart, clearlogos, landscape)
- Recommendations and similar content
- Now Playing / Upcoming movie lists for cinema mode trailers

**Skin variables:** `Includes_TMDB_Variables.xml` maps TMDb Helper's info labels to skin-usable variables.

**Settings writer:** `tmdb_helper_settingswriter.py` can programmatically configure TMDb Helper's settings to ensure optimal integration with the skin.

---

## Skin Shortcuts Integration

Full menu customization via `script.skinshortcuts`:

**Customizable areas:**
- Main menu items and order
- Submenu items per section
- Widget assignments per menu item
- Custom actions and builtins
- Background images per menu section

**Configuration files** in `shortcuts/`:
- `DATA.xml` files define default menu structures
- `overrides.xml` customizes available actions and labels
- `template.xml` defines the menu rendering template
- `builtins/` contains custom action definitions

---

## Localization

The skin supports 10 languages:

| Code | Language |
|---|---|
| `en_us` | English (US) |
| `en_gb` | English (UK) |
| `ar_sa` | Arabic |
| `de_de` | German |
| `es_es` | Spanish |
| `fr_fr` | French |
| `no_no` | Norwegian |
| `pt_br` | Portuguese (Brazil) |
| `sv_se` | Swedish |
| `uk_ua` | Ukrainian |

Translations are stored as `.po` files in `language/resource.language.<code>/strings.po`.

---

## First-Run Experience

On first launch, the skin runs an initialization sequence:

1. **Template application** — Reads `settings_template.xml` and applies all default settings
2. **Background migration** — Ensures background settings are in the current format
3. **TMDb Helper validation** — Checks the addon is installed and enabled, prompts if not
4. **Extras installation** — Offers to download optional image resource packs

This ensures the skin is fully functional without requiring manual configuration. The sequence only runs once (tracked by `Madnox.Settings.Initialized` setting).

---

## Factory Reset

Accessible from skin settings, factory reset:
1. Clears all skin settings
2. Re-applies the default template (`settings_template.xml`)
3. Reloads the skin

This restores the skin to its initial state without requiring reinstallation.
