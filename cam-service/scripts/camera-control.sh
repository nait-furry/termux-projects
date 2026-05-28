#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

HOST="${CAMERA_SERVICE_HOST:-127.0.0.1}"
PORT="${CAMERA_SERVICE_PORT:-8989}"

if [ "$#" -lt 1 ]; then
  echo "usage: camera-control.sh <start|front|back|stop|switch|burst|ping> [arg]" >&2
  exit 2
fi

printf '%s\n' "$*" | nc "$HOST" "$PORT"
