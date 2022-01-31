{ pkgs, ... }: {
  imports = [
    ../common.nix
    ./pam.nix
    ./core.nix
    ./brew.nix
    ./preferences.nix
    ./display-manager.nix
  ];
}
