#!/bin/sh

FLAKE_LOCK_DATE=$(nix flake metadata ~/.config/nixpkgs  2> /dev/null|grep "Last modified" |sed 's/^[^:]*:.....//')
NUM_GENS=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system |wc -l)
LAST_GEN=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system |tail -1)
NUM_VULN_PKGS=$(vulnix -S |grep -A 1 "\----" |grep -v "\--" |wc -l)
NUM_CVES=$(vulnix -S |grep "CVE" |wc -l)
echo "Nixpkgs Last Update: $FLAKE_LOCK_DATE"
echo "Total generations: $NUM_GENS"
echo "Last generation: $LAST_GEN"
echo "Vulnerable packages: $NUM_VULN_PKGS ($NUM_CVES CVES)"
echo
echo "To view vulnerable packages:"
echo "vulnix -S"
echo
echo "To understand what uses a vulnerable package:"
echo "nix-store -q --references /nix/store/ydgqhrcv25qzh76i191xd0p38iyk0h7h-curl-7.82.0.drv"

