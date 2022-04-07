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
echo "To delete previous generations before the last 7:"
echo "sudo nix-env --delete-generations +7 --profile /nix/var/nix/profiles/system"
echo
echo "To garbage collect older than 30d:"
echo "sudo nix-collect-garbage --delete-older-than 30d"
echo
echo "To remove duplicates:"
echo "nix store optimise"
echo
echo "To view vulnerable packages:"
echo "vulnix -S"
#echo
#echo "To update package sources:"
#echo "nix flake update ~/.config/nixpkgs"
