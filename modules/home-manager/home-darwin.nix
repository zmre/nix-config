{ config, lib, pkgs, inputs, ... }: {
  # Can't use networking.extraHosts outside of NixOS, so this hack:
  # company colors -- may still need to "install" them from a color picker window
  home.file."Library/Colors/IronCore-Branding-June-17.clr".source =
    ./dotfiles/IronCore-Branding-June-17.clr;
}
