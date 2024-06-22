{
  inputs,
  username,
  lib,
  pkgs,
  ...
}: {
  time.timeZone = "America/Denver";
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };

  # environment setup
  environment = {
    systemPackages = [pkgs.cachix];
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs-unstable.source = "${inputs.nixpkgs-unstable}";
      nixpkgs-stable.source =
        if pkgs.stdenvNoCC.isDarwin
        then "${inputs.nixpkgs-stable-darwin}"
        else "${inputs.nixpkgs-stable}";
    };
    # list of acceptable shells in /etc/shells
    shells = with pkgs.stable; [bash zsh];
    pathsToLink = ["/libexec" "/share/zsh"];
  };

  # Fixes error about home dir being /var/empty
  # See https://github.com/nix-community/home-manager/issues/4026
  users.users.${username} = {
    home =
      if pkgs.stdenvNoCC.isDarwin
      then "/Users/${username}"
      else "/home/${username}";
  };
  nix = {
    # package = pkgs.nixVersions.nix_2_11;
    package = pkgs.nix;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    settings = {
      # Because macos sandbox can create issues https://github.com/NixOS/nix/issues/4119
      sandbox = false; # !pkgs.stdenv.isDarwin;
      #trusted-users = [ "${config.user.name}" "root" "@admin" "@wheel" ];
      trusted-users = ["${username}" "root" "@admin" "@wheel"];
      # TODO: turn this back on
      # disabled 2023-01-21 because of "cannot link" errors as described here:
      # https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = false;
      max-jobs = 8;
      cores = 0; # use them all
      allowed-users = ["@wheel"];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://zmre.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "zmre.cachix.org-1:WIE1U2a16UyaUVr+Wind0JM6pEXBe43PQezdPKoDWLE="
      ];
    };

    #optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    # From https://nixos.wiki/wiki/Flakes for pinning registry to system packages
    # For reasons I don't understand, the lines below are breaking the build with `error: 'builtins.storePath' is not allowed in pure evaluation mode`
    #registry = {
    #  nixpkgs.to = {
    #    type = "path";
    #    path = pkgs.path;
    #  };
    #};
  };
}
