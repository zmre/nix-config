#!/bin/sh

# commenting out amethyst because i've hand edited it down
# defaults export -app "Amethyst" - > ./amethyst.plist

# Run this after changing hotkeys in Settings
defaults export com.apple.symbolichotkeys.plist - > ./symbolichotkeys.plist

