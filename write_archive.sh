#!/usr/bin/env bash
set -euo pipefail

# Run this with:
# sudo -v
# sudo ./write_archive.sh &
# less "${FILE%.*}_tar.log"

# ─── CONFIGURATION ───────────────────────────────────────────────
FOLDER="/mnt/staging"
FILE="round_2_c2_2702.nd2"               # ← change this to back up a different file
TAPE="/dev/nst0"                  # non‑rewind tape device
# ────────────────────────────────────────────────────────────────

# ─── ARG PARSING ────────────────────────────────────────────────
# If an argument is given:
#  - if it has a slash, treat it as a full path
#  - otherwise, treat it as a filename under $FOLDER
if [[ "${1-}" ]]; then
  if [[ "$1" == */* ]]; then
    SRC_PATH="$1"
    FOLDER="$(dirname -- "$SRC_PATH")"
    FILE="$(basename -- "$SRC_PATH")"
  else
    FILE="$1"
    SRC_PATH="$FOLDER/$FILE"
  fi
else
  SRC_PATH="$FOLDER/$FILE"
fi

LOG="${FILE%.*}_tar.log"

usage() {
  echo "Usage: sudo ./write_archive.sh [filename | /full/path/to/file]"
  echo "If no argument is given, defaults to: $FOLDER/$FILE"
}

# ─── BASIC VALIDATION ───────────────────────────────────────────
if [[ "${1-}" == "-h" || "${1-}" == "--help" ]]; then
  usage; exit 0
fi

if [[ ! -f "$SRC_PATH" ]]; then
  echo "ERROR: Source file not found: $SRC_PATH" >&2
  exit 1
fi

# Detach stdin, and redirect both stdout & stderr into the log
exec > "$LOG" 2>&1 </dev/null

echo "Starting backup of $FILE at $(date)"

# Sanity check tape device
sudo mt -f "$TAPE" status || { echo "ERROR: can't talk to $TAPE"; exit 1; }

# Always move to the end of recorded data before writing
echo "Positioning tape to EOD…"
sudo mt -f "$TAPE" eod  || { echo "ERROR: mt eod failed"; exit 1; }
sudo mt -f "$TAPE" status

# The actual tar‑to‑tape write
tar -cvf "$TAPE" "$SRC_PATH"

echo "Backup of $FILE completed at $(date)"
