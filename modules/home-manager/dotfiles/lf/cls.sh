#!/usr/bin/env bash

# This script and related image scripts originally came from:
# https://github.com/neeshy/lfimg

if [ -n "$FIFO_UEBERZUG" ]; then
  printf '{"action": "remove", "identifier": "preview"}\n' >"$FIFO_UEBERZUG"
elif [ -n "$KITTY_INSTALLATION_DIR" ]; then
  kitty +icat --clear --silent --transfer-mode file
fi
