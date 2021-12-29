{ config, pkgs, ... }: {

  # TODO: chunkwm configs and install
  # https://daiderd.com/nix-darwin/manual/index.html

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = builtins.readFile ../home-manager/dotfiles/skhdrc;
  };
}
