# Madnox - Kodi Skin & Addon Repository

## Session Logs

Session summaries are stored in `.claude/` as markdown files named by session ID. At the end of each session (or when context is compacted), update or create a session log at `.claude/<session-id>.md` with:

- Date
- Work completed (with status: completed, rolled back, in progress)
- Files changed
- Key decisions made
- Pending items not yet addressed

When starting a new session, read the most recent session log in `.claude/` for continuity context.
