# Dependencies

## Core Madnox Addons

These are the addons developed and maintained as part of the Madnox project.

### skin.madnox (Main Skin)

| Dependency | Min Version | Purpose |
|---|---|---|
| `xbmc.gui` | 5.18.0 (Piers) / 5.17.0 (Omega) | Kodi GUI API |
| `script.skin.madnox` | 1.0.5 | Custom helper script for skin logic |
| `resource.images.skin.madnox` | 1.0.1 | Separated image resources (backgrounds, icons, genres) |
| `script.skinshortcuts` | 1.0.17 | Customizable menu/shortcut system |
| `plugin.video.themoviedb.helper` | 6.11.5 | TMDb metadata, artwork, trailers, player routing |
| `script.image.resource.select` | 2.0.4 | Image resource selection dialogs |
| `script.skinvariables` | 2.1.14 | Dynamic skin variable management |
| `script.favourites` | 8.1.2 | Enhanced favourites management |

### script.skin.madnox (Skin Helper)

| Dependency | Min Version | Purpose |
|---|---|---|
| `xbmc.python` | 3.0.0 | Python scripting API |

### resource.images.skin.madnox (Image Resources)

| Dependency | Min Version | Purpose |
|---|---|---|
| `kodi.resource` | 1.0.0 | Kodi resource addon API |

### resource.images.moviegenreicons.filmstrip-hd.bw / .colour

| Dependency | Min Version | Purpose |
|---|---|---|
| `kodi.resource` | 1.0.0 | Kodi resource addon API |

---

## Third-Party Bundled Addons

These addons are not authored by jcastell7 but are bundled in the repository as required dependencies.

### TMDb Helper Suite (by jurialmunkey)

| Addon | Version | Purpose |
|---|---|---|
| `plugin.video.themoviedb.helper` | 6.15.2 | Primary metadata provider. Supplies movie/TV info, artwork, trailers, cast details, and player routing. Replaces the older Embuary Helper used in Nexus. |
| `repository.jurialmunkey` | 3.5 | Repository for TMDb Helper updates independent of Madnox |
| `script.module.jurialmunkey` | 0.2.33 | Shared Python library used by TMDb Helper |
| `script.module.infotagger` | 0.0.8 | Python wrapper for Kodi Nexus+ InfoTag system. Provides backwards-compatible tag writing. |

### Media Enhancement

| Addon | Version | Purpose |
|---|---|---|
| `script.artwork.dump` | 0.4.1 | Automatically downloads and caches artwork (posters, fanart, clearlogos) for local library items. Improves skin rendering speed. |
| `service.tvtunes` | 2.1.4 | Plays TV show/movie theme music while browsing the library. Runs as a background service. |
| `script.preshowexperience` | 0.3.2.1 | Advanced cinema preshow automation. Plays trailers, bumpers, and intros before movies. Integrates with Madnox's cinema mode. |
| `script.wikipedia` | 0.0.8 | Displays Wikipedia articles for actors, directors, and media within the skin's info dialogs. |

### Utility

| Addon | Version | Purpose |
|---|---|---|
| `script.module.pil` | 5.1.0 | Python Imaging Library. Used for image processing operations (color extraction, resizing). |

---

## Version Differences Across Kodi Branches

### Nexus (Legacy) — Additional Dependencies

The Nexus version of skin.madnox had a significantly larger dependency list that was consolidated in Omega/Piers:

| Addon | Purpose | Replaced By (Omega+) |
|---|---|---|
| `script.embuary.helper` | Jump-to-letter, metadata helpers | `script.skin.madnox` (native implementation) |
| `script.cu.lrclyrics` | Synchronized lyrics display | Still supported via skin XML integration |
| `script.module.embuary.info` | Extended info dialogs | `plugin.video.themoviedb.helper` |
| `script.library.node.editor` | Custom library nodes | Removed |
| `script.rss.editor` | RSS feed management | Still supported via skin XML |
| `service.upnext` | Up Next episode notifications | Still supported via skin XML |
| `script.artistslideshow` | Artist background slideshows | Removed |
| `resource.images.*` (multiple) | Various icon packs | Consolidated into `resource.images.skin.madnox` |

### Omega vs Piers

The addon sets are identical. The only differences are:
- `skin.madnox` version: 21.10.08 (Omega) vs 22.10.08 (Piers)
- `xbmc.gui` requirement: 5.17.0 (Omega) vs 5.18.0 (Piers)

---

## Dependency Graph

```
skin.madnox
├── script.skin.madnox
│   └── xbmc.python
├── resource.images.skin.madnox
│   └── kodi.resource
├── script.skinshortcuts (external - Kodi repo)
├── plugin.video.themoviedb.helper
│   ├── script.module.jurialmunkey
│   └── script.module.infotagger
├── script.image.resource.select (external - Kodi repo)
├── script.skinvariables (external - Kodi repo)
└── script.favourites (external - Kodi repo)
```

Addons marked "external - Kodi repo" are available from the official Kodi addon repository and are not bundled here. They are installed automatically by Kodi's dependency resolver.
