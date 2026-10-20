#!/usr/bin/env bash
# Build the ESPHome firmware in Docker and flash it over the network (OTA).
# Usage: ./flash.sh [device-ip] [config.yaml]
set -euo pipefail

cd "$(dirname "$0")"

DEVICE="${1:-172.16.3.68}"
CONFIG="${2:-ezplug-073548.yaml}"
SECRETS="${SECRETS:-$HOME/esp/secrets.yaml}"
IMAGE="${ESPHOME_IMAGE:-ghcr.io/esphome/esphome:latest}"

if [[ ! -f "$SECRETS" ]]; then
  echo "secrets file not found: $SECRETS (set SECRETS=/path/to/secrets.yaml)" >&2
  exit 1
fi

# --network host: the OTA upload connects straight to the device IP on port 3232
exec docker run --rm -it --network host \
  -v "$PWD":/config \
  -v "$SECRETS":/config/secrets.yaml:ro \
  "$IMAGE" run --no-logs --device "$DEVICE" "$CONFIG"
