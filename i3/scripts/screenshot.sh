#!/usr/bin/env bash

MODE="$1"
DIR="$HOME/Pictures/Screenshots"
FILE="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

case "$MODE" in
  full)
    maim "$FILE"
    ;;
  select)
    maim -s "$FILE"
    ;;
  window)
    maim -i "$(xdotool getactivewindow)" "$FILE"
    ;;
  select-clip)
    maim -s | xclip -selection clipboard -t image/png
    notify-send "Screenshot" "Copied selection to clipboard"
    exit 0
    ;;
esac

if [ -f "$FILE" ]; then
  xclip -selection clipboard -t image/png -i "$FILE"
  notify-send "Screenshot saved" "$FILE"
fi
