{ inputs, config, lib, pkgs, nixpkgs, stable, nur, ... }: {
  nixpkgs.config = {
    allowUnsupportedSystem = true;
    allowBroken = false;
    allowUnfree = true;
    experimental-features = "nix-command flakes";
  };
  nixpkgs.overlays = [ ];
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      allowUnfree = true
      ${lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes"}
    '';
    useSandbox = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "${config.user.name}" "root" "@admin" "@wheel" ];
    autoOptimiseStore = true;
    optimise.automatic = true;
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
        #"small"
        "stable"
        #"trunk"
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

      # trunk = {
      #   from = {
      #     id = "trunk";
      #     type = "indirect";
      #   };
      #   flake = inputs.trunk;
      # };

      # small = {
      #   from = {
      #     id = "small";
      #     type = "indirect";
      #   };
      #   flake = inputs.small;
      # };
    };
  };
}
