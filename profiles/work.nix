{ config, lib, pkgs, ... }: {
  user.name = "pwalsh";
  hm = { imports = [ ./home-manager/work.nix ]; };
}
