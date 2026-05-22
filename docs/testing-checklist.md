# Testing Checklist

Manual testing procedures for new and modified skin features. Test with the Madnox skin active in Kodi.

---

## Editable Music Queue

### New: Slide-Out Queue Panel (Custom_1133_MusicQueuePanel.xml)

A right-side slide-out panel accessible from the Music OSD that shows the current playlist with reorder/remove controls.

**Prerequisites:**
- Add at least 5 songs to the music playlist before testing

**Test: Opening the panel from Music OSD**
1. Play any music track
2. Bring up the Music OSD (move mouse to top of screen or press M)
3. Press the playlist button (list icon, right side of OSD)
4. Expected: A 420px panel slides in from the right edge with a smooth animation (~480ms)
5. Expected: The OSD remains visible behind the panel

**Test: Panel content display**
1. Open the queue panel while music is playing
2. Expected: Panel header shows "Queue" label and a close (X) button
3. Expected: All queued tracks are listed with title, artist, and duration
4. Expected: The currently playing track shows a play icon on the left

**Test: Reorder tracks**
1. Open the queue panel
2. Navigate to a track in the list (not the first one)
3. Press the "Move Up" button at the bottom of the panel
4. Expected: The selected track moves one position up in the list
5. Navigate to a track (not the last one)
6. Press the "Move Down" button
7. Expected: The selected track moves one position down in the list

**Test: Remove track**
1. Open the queue panel
2. Navigate to any track in the list
3. Press the "Remove" button at the bottom of the panel
4. Expected: The track is removed from the playlist
5. Expected: The list updates immediately

**Test: Navigation flow**
1. Open the queue panel
2. Press Up repeatedly from the top of the list
3. Expected: Focus moves to the close button (X)
4. Press Down from the close button
5. Expected: Focus returns to the playlist list
6. Press Down from the bottom of the list
7. Expected: Focus moves to the action buttons (Move Up / Move Down / Remove)
8. Press Up from the action buttons
9. Expected: Focus returns to the playlist list

**Test: Closing the panel**
1. Open the queue panel
2. Press Back/Escape
3. Expected: Panel slides out to the right and closes, returning to the OSD
4. Alternatively, navigate to the X button and press Enter
5. Expected: Same close behavior

**Test: Scrollbar**
1. Add 15+ songs to the playlist
2. Open the queue panel
3. Expected: A vertical scrollbar appears on the right edge of the list
4. Scroll through the list
5. Expected: Scrollbar thumb moves proportionally

---

### Modified: Music OSD Playlist Button (MusicOSD.xml)

The playlist button in the Music OSD now opens the slide-out queue panel instead of navigating to the full-screen playlist window.

**Test: Button behavior change**
1. Play music and open the Music OSD
2. Press the playlist/list button (right side group)
3. Expected: The slide-out queue panel opens as an overlay
4. Expected: Music continues playing without interruption
5. Expected: Does NOT navigate away to the full-screen MyPlaylist window

**Test: Visibility conditions**
1. The playlist button should NOT appear when:
   - Playing LiveTV content
   - `MusicOSDDisablePlaylistButton` skin setting is enabled

---

### New: MyPlaylist Media Menu Buttons (Includes_MediaMenu.xml)

Three new buttons added to the left sidebar of the full-screen Music Playlist view (MyPlaylist.xml).

**Test: Button visibility**
1. Navigate to Music > Playlist (the full-screen playlist view)
2. Expected: The left sidebar shows the existing buttons (Shuffle, Repeat, Save, Clear) plus three new ones: Move Up, Move Down, Remove

**Test: Move Up**
1. In the full-screen playlist, select a track (not the first)
2. In the left sidebar, press the "Move Up" button
3. Expected: The selected track moves one position up

**Test: Move Down**
1. Select a track (not the last)
2. Press the "Move Down" button
3. Expected: The selected track moves one position down

**Test: Remove**
1. Select any track
2. Press the "Remove" button
3. Expected: The track is removed from the playlist

---

## General Regression Checks

After testing new features, verify these existing behaviors still work:

| Area | Check |
|---|---|
| Music OSD | All other OSD buttons (stop, play/pause, prev, next, repeat, shuffle) still function |
| Music OSD | OSD auto-hides after inactivity |
| MyPlaylist | Existing Shuffle/Repeat/Save/Clear buttons still work |
| MyPlaylist | Double-clicking a track in the playlist starts playback |
| Home Dashboard | Widget View (window 1130) still opens correctly from home screen |
| Visualizations | Visualization preset/settings buttons in Music OSD still work |
