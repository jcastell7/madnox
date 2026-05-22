# Cinema Mode

## Overview

Cinema Mode (`madnox_cinema.py`) provides a full theatrical experience before playing a movie. It builds a playlist sequence that mimics a real cinema: intros, trailers with bumpers, audio format announcements, rating cards, countdowns, and finally the main feature.

## Playlist Sequence

When activated, Cinema Mode builds and plays the following sequence in order:

```
1. Feature Intro        → Random video from Feature_Intros/
2. Trailer Intro        → Bumper before trailers begin
3. Trailers (1-N)       → From TMDb or local library
4. Trailer Outro        → Bumper after trailers end
5. Audio Codec Bumper   → Auto-detected from movie's audio stream
6. Courtesy Bumper      → "Please silence your phones" style clip
7. MPAA Rating Bumper   → Based on movie's content rating
8. Countdown            → Pre-feature countdown video
9. Main Movie           → The selected film
10. Feature Outro       → Post-movie bumper
```

Each step is optional — if the corresponding folder is empty or the file doesn't exist, that step is skipped gracefully.

## Required Folder Structure

Cinema Mode requires a user-configured base path (`IntroPath` skin setting) with the following subdirectories:

```
<IntroPath>/
├── Feature_Intros/          # Random pre-show intro videos
├── Trailer_Intros/          # "Coming Attractions" bumpers
├── Trailer_Outros/          # "Feature Presentation" bumpers
├── Courtesy/                # Courtesy/etiquette reminders
├── Countdowns/              # Final countdown before movie
├── Feature_Outros/          # Post-movie bumpers
├── Intros/                  # General intro videos
├── Audio/                   # Audio format announcement bumpers
│   ├── Stereo/
│   ├── Dolby TrueHD/
│   ├── Dolby Atmos/
│   ├── DTS-HD Master Audio/
│   ├── DTS/
│   ├── Dolby Digital Plus/
│   ├── Dolby Digital/
│   ├── Dolby Stereo/
│   ├── Auro-3D/
│   ├── DTS-X/
│   ├── THX/
│   └── Datasat/
└── Ratings/                 # MPAA rating card videos
    ├── G/
    ├── PG/
    ├── PG-13/
    ├── R/
    ├── NC-17/
    └── NR/
```

## Configuration

### Trailer Sources

Cinema Mode can source trailers from two locations:

| Source | Description |
|---|---|
| **TMDb (Now Playing)** | Currently in-theater movies from The Movie Database |
| **TMDb (Upcoming)** | Soon-to-release movies from TMDb |
| **Local Library** | Trailers from the user's own Kodi library |

The number of trailers is configurable via skin settings.

### Audio Codec Detection

The audio bumper is automatically selected based on the movie's primary audio stream codec. The detection maps audio codec IDs to folder names:

| Detected Codec | Folder Used |
|---|---|
| TrueHD + Atmos object metadata | `Dolby Atmos/` |
| TrueHD | `Dolby TrueHD/` |
| DTS-HD MA + X object metadata | `DTS-X/` |
| DTS-HD MA | `DTS-HD Master Audio/` |
| DTS | `DTS/` |
| EAC3 (E-AC-3) | `Dolby Digital Plus/` |
| AC3 | `Dolby Digital/` |
| Stereo (2ch) | `Stereo/` |
| Datasat | `Datasat/` |
| Auro-3D | `Auro-3D/` |

### MPAA Rating Detection

The rating bumper is selected based on the movie's MPAA certification field in Kodi's database:

| Rating | Folder Used |
|---|---|
| G | `Ratings/G/` |
| PG | `Ratings/PG/` |
| PG-13 | `Ratings/PG-13/` |
| R | `Ratings/R/` |
| NC-17 | `Ratings/NC-17/` |
| Not Rated / Unknown | `Ratings/NR/` |

## Theme Support

Cinema Mode supports themed bumper sets. Files can be named with a theme prefix, and the system will group matching files together for a consistent visual experience throughout the sequence.

For example, if your files are prefixed with `retro_`:
- `Trailer_Intros/retro_coming_soon.mp4`
- `Trailer_Outros/retro_feature_presentation.mp4`
- `Countdowns/retro_countdown.mp4`

When a theme is active, Cinema Mode selects files matching that theme prefix across all folders.

## Setup Wizard

Cinema Mode includes a setup wizard that can automatically create the required folder structure at the user's chosen path. This is accessible from the skin settings and creates all necessary subdirectories with the correct naming.

## Validation

Before running, Cinema Mode performs silent validation checks:
- Verifies the base `IntroPath` is set and accessible
- Checks that at minimum the movie can be played (graceful degradation)
- Missing folders or empty directories are skipped without error
- Logs warnings for missing components but does not interrupt playback

## Integration with PreShow Experience

Cinema Mode can work alongside `script.preshowexperience` for users who want even more advanced preshow automation. When both are configured, PreShow Experience handles the trailer/bumper sequencing while Cinema Mode provides the skin integration layer.

## Invoking Cinema Mode

From skin XML:
```xml
<onclick>RunScript(script.skin.madnox, action=madnox_cinema, dbid=$INFO[ListItem.DBID])</onclick>
```

The `dbid` parameter identifies which movie to play, allowing Cinema Mode to read its audio codec and rating information from the Kodi database.
