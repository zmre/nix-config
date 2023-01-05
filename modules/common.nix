{ inputs, username, lib, pkgs, ... }: {

  time.timeZone = "America/Denver";
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };

  # environment setup
  environment = {
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs-unstable.source = "${inputs.nixpkgs-unstable}";
      nixpkgs-stable.source = "${inputs.nixpkgs-stable}";
    };
    # list of acceptable shells in /etc/shells
    shells = with pkgs.stable; [ bash zsh ];
    pathsToLink = [ "/libexec" ];
  };

  nix = {
    package = pkgs.nixVersions.nix_2_11;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    settings = {
      # Because macos sandbox can create issues https://github.com/NixOS/nix/issues/4119
      sandbox = false; # !pkgs.stdenv.isDarwin;
      #trusted-users = [ "${config.user.name}" "root" "@admin" "@wheel" ];
      trusted-users = [ "${username}" "root" "@admin" "@wheel" ];
      auto-optimise-store = true;
      max-jobs = 8;
      cores = 0; # use them all
      allowed-users = [ "@wheel" ];
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
  };

}
