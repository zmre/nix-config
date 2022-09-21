{ pkgs, ... }: {
  imports = [
    ../common.nix
    ./pam.nix # enableSudoTouchIdAuth is now in nix-darwin, but without the reattach stuff for tmux
    ./core.nix
    ./brew.nix
    ./preferences.nix
    ./display-manager.nix
  ];
}
