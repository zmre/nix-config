{ pkgs, nix, nixpkgs, config, lib, ... }: {
  nix = {
    #package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
