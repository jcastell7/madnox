# Skin Configuration

## Overview

The Madnox skin is configured through Kodi's skin settings panel (`SkinSettings.xml`). Settings are organized into 8 categories accessible from a left-side navigation list.

## Settings Categories

### 1. General

General skin behavior and display options:
- Startup intro video selection and preview
- Home screen widget count and layout mode (Carousel / Grid)
- Menu customization via Skin Shortcuts
- Clock format (12h / 24h)
- First-run initialization and factory reset

### 2. Themes

Panel texture themes that control the visual style of windows and dialogs:

| Theme | Description |
|---|---|
| **Default** | Standard rounded/square panel textures |
| **Auriga** | Alternative panel style with distinct borders |
| **Nox4** | Classic Aeon Nox 4 inspired panels |

Each theme supports a **square corners** toggle (`PanelSquare.texture` setting) vs the default rounded corners. Theme textures apply to: panels/windows, half-panels, side-panels, wide panels, dialogs, scan dialogs, and volume dialogs.

### 3. Colors

The skin uses a dual color system:

**Named Colors** (`colors/defaults.xml`) — 25 base colors defined as ARGB hex values:

| Color Name | Usage |
|---|---|
| `red` | Alerts, errors |
| `blue` | Accents |
| `disabled` | Inactive elements |
| `invalid` | Validation errors |
| `panel` | Panel backgrounds |
| `dialog` | Dialog backgrounds |
| `paneltexture` | Panel texture tint |
| `emboss` | Emboss effects |
| `shadow` | Drop shadows |
| `highlight` | Selection highlights |
| `text` | Primary text |
| `subtext` | Secondary text |
| `focustext` | Focused item text |
| `listseparator` | List dividers |
| `button` | Button backgrounds |
| `widget` | Widget containers |
| `mainmenu` | Main menu items |
| `gradientbackground` | Gradient overlays |
| `topbar` | Top bar background |
| `topbarshadow` | Top bar shadow |
| `rssbackground` | RSS ticker background |
| `floor` | Floor reflection area |
| `background` | Global background |
| `mediaflag` | Media flag badges |

**Custom RGBA Color Picker** — A skin-native color picker dialog (`Custom_1104_DialogOverlayColorPicker.xml`) powered by `core_color_helper.py` that allows granular per-channel color adjustment beyond Kodi's built-in picker.

### 4. Backgrounds

Background image configuration:
- Global background image/slideshow
- Per-section background overrides
- Background migration tool for settings format changes

### 5. Furniture

Visual furniture elements:
- Floor reflections
- Gradients and overlays
- Panel opacity and blur settings

### 6. Artwork

Media artwork display options:
- Artwork sources and fallbacks
- ClearLogo display settings
- Fanart handling
- CD art for music

### 7. Addons

Addon integration management:
- Repository status indicator (installed/enabled/version)
- TMDb Helper validation and settings
- Optional extras installation (additional image resources)
- PreShow Experience configuration

The settings panel shows a status variable (`AddonMadnoxRepoVar`) indicating whether `repository.madnox` is installed, enabled, or missing.

### 8. Advanced

Power-user settings:
- Debug options
- Performance tuning
- Media flag display mode (color/greyscale)
- Codec flag overrides

---

## View Modes

The skin provides 40+ customizable view modes organized by type:

### List Views (IDs 050-063)

| ID | Name | Description |
|---|---|---|
| 050 | CoverList | Cover art with list details |
| 051 | SimpleList | Minimal text list |
| 052 | ShowcaseHero | Large hero image with list |
| 053 | InfoList1 | Detailed info list variant 1 |
| 054 | InfoList2 | Detailed info list variant 2 |
| 055 | LowList | Compact low-profile list |
| 056 | 3Panel | Three-panel split view |
| 057 | 3Panel (alt) | Three-panel variant |
| 058 | RightList | Right-aligned list |
| 059 | Spotlight | Spotlight/featured item view |
| 060 | CinematicShelf | Cinematic shelf layout |
| 061 | Editorial | Editorial/magazine style |
| 062 | Immersive | Full-screen immersive |
| 063 | Stage | Stage presentation view |

### Grid Views (IDs 500-512)

| ID | Name | Description |
|---|---|---|
| 500 | Portrait | Portrait aspect grid |
| 501 | Square | Square aspect grid |
| 502 | Banner | Banner/wide aspect grid |
| 503 | Landscape | Landscape aspect grid |
| 504-505 | Focus | Focused item with grid |
| 506-507 | Cascade | Cascading grid layout |
| 508-509 | Showcase | Showcase with grid |
| 510-512 | KodiFlix | Netflix-style rows |

### Icon Views (IDs 520-524)

| ID | Name |
|---|---|
| 520 | PortraitIcon |
| 521 | SquareIcon |
| 522 | BannerIcon |
| 523 | LandscapeIcon |
| 524 | SquareIconAlbums |

### Icon+Info Views (IDs 530-533)

| ID | Name |
|---|---|
| 530 | PortraitIconInfo |
| 531 | SquareIconInfo |
| 532 | BannerIconInfo |
| 533 | LandscapeIconInfo |

### Wall Views (IDs 540-543)

| ID | Name |
|---|---|
| 540 | PortraitWall |
| 541 | SquareWall |
| 542 | BannerWall |
| 543 | LandscapeWall |

---

## Skin XML Architecture

The skin's UI is defined in `16x9/` containing ~177 XML files:

### File Organization

| Category | Files | Purpose |
|---|---|---|
| Core Windows | `Home.xml`, `Startup.xml`, `LoginScreen.xml`, `Settings.xml`, `SkinSettings.xml` | Main navigation screens |
| View Definitions | `View_*.xml` | Individual view mode layouts |
| Custom Dialogs | `Custom_1100-1190_*.xml` | Skin-specific dialog windows |
| Standard Dialogs | `Dialog*.xml` | Kodi standard dialog overrides |
| Include Files | `Includes_*.xml`, `includes.xml` | Reusable UI components |
| Script Integration | `script-*.xml` | Third-party addon UI integration |
| Variables | `Variables*.xml` | Dynamic value definitions |

### Include Files

| File | Purpose |
|---|---|
| `includes.xml` | Master include definitions |
| `Includes_Animations.xml` | Animation definitions |
| `Includes_Backgrounds.xml` | Background rendering logic |
| `Includes_CustomSelect.xml` | Custom selection dialog components |
| `Includes_Dialogs.xml` | Dialog component includes |
| `Includes_Home.xml` | Home screen components |
| `Includes_Home_Dashboards.xml` | Dashboard widget layouts |
| `Includes_InfoDialogs.xml` | Media info dialog layouts |
| `Includes_MediaFlags.xml` | Codec/quality flag rendering |
| `Includes_MediaMenu.xml` | Media section menus |
| `Includes_NowPlaying.xml` | Now playing overlays |
| `Includes_PVR.xml` | PVR/Live TV components |
| `Includes_Settings.xml` | Settings panel components |
| `Includes_Themes.xml` | Theme texture definitions |
| `Includes_ThemeSelect.xml` | Theme selection UI |
| `Includes_TMDB_Variables.xml` | TMDb Helper variable mappings |
| `Includes_Topbar.xml` | Top bar/header components |
| `Includes_VideoLyrics.xml` | Lyrics display overlay |
| `Includes_Views.xml` | View mode shared components |
| `Includes_ViewsVariables.xml` | View-specific variables |

---

## Fonts

The skin bundles 10 font files:

| Font | Usage |
|---|---|
| Bebas Neue | Headers, titles |
| DejaVu Sans | Fallback/unicode |
| Material Design Icons | UI icons (MDI) |
| Material Icons | Additional UI icons |
| Noto Mono | Monospace text |
| Noto Sans | Body text alternative |
| Open Sans (Bold/Regular/Condensed) | Primary UI text |
| Roboto Thin | Light-weight display text |

---

## Shortcuts System

The `shortcuts/` directory contains Skin Shortcuts configuration:

- `DATA.xml` files for each menu section (mainmenu, movies, music, tvshows, etc.)
- `overrides.xml` — custom action/label overrides
- `template.xml` — menu template definitions
- `builtins/` — custom builtin action definitions

This integrates with `script.skinshortcuts` to provide fully user-customizable menus throughout the skin.
