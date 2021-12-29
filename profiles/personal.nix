{ config, lib, pkgs, ... }: {
  user.name = "zmre";
  hm = { imports = [ ./home-manager/personal.nix ]; };
}
