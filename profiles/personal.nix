{ config, lib, pkgs, ... }: {
  user.name = "zmre";
  hm = {
    imports =
      [ ./home-manager/personal.nix ../modules/home-manager/home-security.nix ];
  };
}
