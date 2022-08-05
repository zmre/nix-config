{ inputs, config, lib, pkgs, nixpkgs, stable, ... }: {
  nixpkgs = {
    config = import ../config.nix;
    overlays = [ ];
  };
  nix = {
    package = pkgs.stable.nix_2_6;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      ${lib.optionalString (config.nix.package == pkgs.stable.nix_2_6)
      "experimental-features = nix-command flakes"}
    '';
    #settings = {
    #useSandbox = true;
    #allowedUsers = [ "@wheel" ];
    #trustedUsers = [ "${config.user.name}" "root" "@admin" "@wheel" ];
    #maxJobs = 8;
    #buildCores = 0; # use them all
    #};
    #autoOptimiseStore = true;
    #optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
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
