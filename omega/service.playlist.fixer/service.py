import os
import xbmc
import xbmcvfs

SOURCE_DIR = '/media/mmcblk1p1-mmc-SD_0x00000681-pa/files/Playlists'
DEST_DIR = '/storage/.kodi/userdata/playlists/music'
PATH_PREFIX = '/media/mmcblk1p1-mmc-SD_0x00000681-pa/files/'
POLL_INTERVAL = 60


def log(msg):
    xbmc.log('PlaylistFixer: {}'.format(msg), xbmc.LOGINFO)


def ensure_dest_dir():
    if not xbmcvfs.exists(DEST_DIR + '/'):
        xbmcvfs.mkdirs(DEST_DIR)
        log('Created destination directory: {}'.format(DEST_DIR))


def get_source_files():
    files = {}
    if not os.path.isdir(SOURCE_DIR):
        return files
    for entry in os.listdir(SOURCE_DIR):
        if entry.lower().endswith('.m3u'):
            filepath = os.path.join(SOURCE_DIR, entry)
            try:
                files[entry] = os.path.getmtime(filepath)
            except OSError:
                pass
    return files


def fix_playlist(source_path):
    with open(source_path, 'r', encoding='utf-8', errors='replace') as f:
        lines = f.readlines()

    fixed_lines = []
    for line in lines:
        stripped = line.rstrip('\r\n')
        if stripped.startswith('#') or stripped == '':
            fixed_lines.append(line)
        else:
            if stripped.startswith('Music/'):
                stripped = PATH_PREFIX + stripped
            fixed_lines.append(stripped + '\n')
    return ''.join(fixed_lines)


def write_playlist(filename, content):
    dest_path = os.path.join(DEST_DIR, filename)
    try:
        with open(dest_path, 'w', encoding='utf-8') as f:
            f.write(content)
        log('Wrote fixed playlist: {}'.format(filename))
    except IOError as e:
        log('Error writing {}: {}'.format(filename, e))


def process_playlists():
    source_files = get_source_files()
    if not source_files:
        return

    ensure_dest_dir()

    for filename, mtime in source_files.items():
        source_path = os.path.join(SOURCE_DIR, filename)
        dest_path = os.path.join(DEST_DIR, filename)

        if os.path.exists(dest_path):
            try:
                dest_mtime = os.path.getmtime(dest_path)
                if dest_mtime >= mtime:
                    continue
            except OSError:
                pass

        try:
            content = fix_playlist(source_path)
            write_playlist(filename, content)
        except (IOError, OSError) as e:
            log('Error processing {}: {}'.format(filename, e))


class PlaylistFixerService(xbmc.Monitor):
    def __init__(self):
        super(PlaylistFixerService, self).__init__()
        log('Service started')
        process_playlists()
        while not self.waitForAbort(POLL_INTERVAL):
            process_playlists()
        log('Service stopped')


if __name__ == '__main__':
    PlaylistFixerService()
