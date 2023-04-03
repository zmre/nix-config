#!/bin/bash

dwshowupdates() {
  local VERSIONS=($(ls -1dt '/nix/var/nix/profiles/system-*-link' |head -2))
  nix store diff-closures "${VERSIONS[1]}" "${VERSIONS[0]}" # | grep --color -E '→|$'
}
