#!/bin/bash -ex

# Grab configuration from the environment, or use defaults
SAVENAME="${FACTORIO_SAVENAME:-headless}"
LATENCY="${FACTORIO_LATENCY_MS:-50}"
AUTOSAVE_INTERVAL="${FACTORIO_AUTOSAVE_INTERVAL:-5}"
AUTOSAVE_SLOTS="${FACTORIO_AUTOSAVE_SLOTS:-3}"
# If you want to pass any other args to the server command
EXTRA_OPTS="${FACTORIO_EXTRA_OPTS:-}"

# Create the savegame if it doesn't already exist.
if [ ! -f "/opt/factorio/saves/$SAVENAME.zip" ]; then
  /opt/factorio/bin/x64/factorio --create "$SAVENAME"
fi

# Run the server
/opt/factorio/bin/x64/factorio \
  --start-server "$SAVENAME" \
  --latency-ms "$LATENCY" \
  --autosave-interval "$AUTOSAVE_INTERVAL" \
  --autosave-slots "$AUTOSAVE_SLOTS" \
  $EXTRA_OPTS
