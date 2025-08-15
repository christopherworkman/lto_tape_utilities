#!/usr/bin/env bash
set -euo pipefail

# Run this with:
# sudo -v
# sudo ./write_archive.sh &
# less "${FILE%.*}_tar.log"

# ─── CONFIGURATION ───────────────────────────────────────────────
FOLDER="/mnt/staging"
FILE="filename.nd2"               # ← change this to back up a different file
TAPE="/dev/nst0"                  # non‑rewind tape device
LOG="${FILE%.*}_tar.log"          # e.g. filename_tar.log
# ────────────────────────────────────────────────────────────────

# Detach stdin, and redirect both stdout & stderr into the log
exec > "$LOG" 2>&1 </dev/null

echo "Starting backup of $FILE at $(date)"

# The actual tar‑to‑tape write
tar -cvf "$TAPE" "$FOLDER"/"$FILE"

echo "Backup of $FILE completed at $(date)"
