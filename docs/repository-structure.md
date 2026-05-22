# Repository Structure

## Overview

This repository serves as a self-hosted Kodi addon repository. It distributes the Madnox skin and its dependencies to users across multiple Kodi versions through version-gated directories.

## Directory Layout

```
madnox/
├── repo/                          # Repository addon (bootstrap layer)
│   ├── repository.madnox/         # Source addon files
│   │   ├── addon.xml
│   │   ├── fanart.jpg
│   │   └── icon.png
│   └── zips/                      # Packaged addon + manifest
│       ├── addons.xml             # Self-referential manifest (repo addon only)
│       ├── addons.xml.md5
│       └── repository.madnox/
│           ├── addon.xml
│           ├── fanart.jpg
│           ├── icon.png
│           └── repository.madnox-1.0.11.zip
├── nexus/                         # Kodi Nexus (v20.x) - legacy
│   ├── skin.madnox/              # Skin source
│   └── zips/                     # Packaged addons + manifest
│       ├── addons.xml
│       ├── addons.xml.md5
│       └── <addon-id>/           # One folder per addon with zip
├── omega/                         # Kodi Omega (v21.0.0 - 21.9.0)
│   ├── skin.madnox/
│   ├── script.skin.madnox/
│   ├── resource.images.skin.madnox/
│   ├── resource.images.moviegenreicons.filmstrip-hd.bw/
│   ├── resource.images.moviegenreicons.filmstrip-hd.colour/
│   └── zips/                     # Packaged addons + manifest
├── piers/                         # Kodi Piers (v21.9.1+) - latest
│   ├── skin.madnox/
│   ├── script.skin.madnox/
│   ├── resource.images.skin.madnox/
│   ├── resource.images.moviegenreicons.filmstrip-hd.bw/
│   ├── resource.images.moviegenreicons.filmstrip-hd.colour/
│   └── zips/                     # Packaged addons + manifest
├── _repo_generator.py            # Legacy repo generator
├── _repo_generator_v2.py         # V2 repo generator
├── _repo_generator_v3.py         # Current repo generator
├── index.html                    # GitHub Pages entry point
├── repository.madnox-1.0.11.zip  # Root-level zip for direct download
├── README.md                     # Project readme
└── docs/                         # Documentation (this folder)
```

## Version-Gating Mechanism

The repository addon (`repo/repository.madnox/addon.xml`) uses Kodi's `<dir>` elements with `minversion`/`maxversion` attributes to serve different addon sets based on the user's Kodi version:

| Kodi Version | Branch | Directory Served |
|---|---|---|
| Fallback (any) | `repo/zips/` | Repository addon only |
| 20.0.0 - 20.9.9 (Nexus) | `nexus/zips/` | Legacy skin + dependencies |
| 21.0.0 - 21.9.0 (Omega) | `omega/zips/` | Full skin suite |
| 21.9.1+ (Piers) | `piers/zips/` | Latest skin suite |

Each branch's `zips/` directory contains:
- `addons.xml` — manifest listing all available addons with metadata
- `addons.xml.md5` — checksum for cache invalidation
- One subdirectory per addon containing its `addon.xml` and versioned `.zip` file

## GitHub Pages Distribution

The `index.html` at the repository root is a minimal HTML file that links to `repository.madnox-1.0.11.zip`. When GitHub Pages is enabled on the repository, this creates a URL that users can add as a Kodi file source:

```
https://jcastell7.github.io/madnox/
```

Kodi reads this page, finds the zip link, and allows users to install the repository addon. Once installed, the repository addon handles all future updates automatically via the version-gated raw GitHub URLs.

## How Updates Flow

1. User installs `repository.madnox` via the GitHub Pages zip
2. Kodi checks the repository's `addons.xml` periodically
3. The version-gated `<dir>` blocks route Kodi to the correct branch's `zips/addons.xml`
4. Kodi compares installed addon versions against the manifest
5. If newer versions exist, Kodi downloads the updated zip from the corresponding `zips/<addon-id>/` directory

## Repo Generator Scripts

The `_repo_generator_v3.py` script automates building the `zips/` directories:

1. Scans source addon directories for `addon.xml` files
2. Creates zip packages of each addon
3. Generates the `addons.xml` manifest by concatenating all addon metadata
4. Computes the `addons.xml.md5` checksum

Run from the repository root to regenerate packages after making changes to addon source files.

## Branch Differences

### Nexus (Legacy)
- Older skin version (21.02.04) with larger dependency set
- Uses Embuary Helper instead of TMDb Helper
- No dedicated skin helper script
- No separated image resources addon

### Omega → Piers (Active)
- Nearly identical addon sets
- Skin version differs (21.10.08 vs 22.10.08)
- GUI API version requirement differs (5.17.0 vs 5.18.0)
- Major architectural change from Nexus: migrated to TMDb Helper, added script.skin.madnox helper
