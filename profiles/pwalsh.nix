{ config, lib, pkgs, ... }: {
  user.name = "pwalsh";
  hm = {
    imports = [
      #./home-manager/personal.nix
      #../modules/home-manager/home-security.nix
    ];
  };
}
