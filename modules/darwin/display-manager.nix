{ config, pkgs, ... }: {


  services.skhd = {
    enable = false;
    #package = pkgs.skhd;
    skhdConfig = builtins.readFile ../home-manager/dotfiles/skhdrc;
  };
  # TODO: chunkwm configs and install
  # https://daiderd.com/nix-darwin/manual/index.html
  #services.chunkwm = {
    #package = pkgs.chunkwm;
    #hotload = true;
    #plugins = {
      #dir = "${lib.getOutput "out" pkgs.chunkwm}/lib/chunkwm/plugins";
      #list = [ "tiling" ];
      #"tiling".config = ''
      #chunkc set global_desktop_mode   bsp
      #'';
    #};
    #extraConfig = builtins.readFile ./dotfiles/chunkwmrc;
  #};
}
