{ inputs, config, lib, pkgs, nixpkgs, stable, ... }: {
  nixpkgs = {
    config = import ../config.nix;
    overlays = [ ];
  };
  nix = {
    package = pkgs.stable.nix_2_4;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      ${lib.optionalString (config.nix.package == pkgs.stable.nix_2_4)
      "experimental-features = nix-command flakes"}
    '';
    useSandbox = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "${config.user.name}" "root" "@admin" "@wheel" ];
    #autoOptimiseStore = true;
    #optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    buildCores = 0; # use them all
    maxJobs = 8;
    readOnlyStore = true;
    nixPath = builtins.map
      (source: "${source}=/etc/${config.environment.etc.${source}.target}") [
      "home-manager"
      "nixpkgs"
      "stable"
    ];

    registry = {
      nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        flake = nixpkgs;
      };

      stable = {
        from = {
          id = "stable";
          type = "indirect";
        };
        flake = stable;
      };
    };
  };
}
