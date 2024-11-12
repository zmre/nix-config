{
  description = "zmre nix cross-platform system configurations";
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://zmre.cachix.org"
      "https://yazi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "zmre.cachix.org-1:WIE1U2a16UyaUVr+Wind0JM6pEXBe43PQezdPKoDWLE="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
    ];
  };

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    ## TODO: not sure if it matters, but probably worth threading -darwin version through on darwin builds
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # defaulting to unstable these days

    flake-compat = {
      # Needed along with default.nix in root to allow nixd lsp to do completions
      # See: https://github.com/nix-community/nixd/tree/main/docs/examples/flake
      url = "github:inclyc/flake-compat";
      flake = false;
    };
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # I use the nur repo for firefox extensions
    nur.url = "github:nix-community/NUR";

    pwnvim.url = "github:zmre/pwnvim";
    pwneovide.url = "github:zmre/pwneovide";
    # pwneovide.inputs.pwnvim.follows = "pwnvim";

    ironhide.url = "github:IronCoreLabs/ironhide";
    ironhide.inputs.nixpkgs.follows = "nixpkgs-unstable";

    hackernews-tui.url = "github:aome510/hackernews-TUI";
    hackernews-tui.flake = false;
    # fenix needed to build hackernews with older rustc for now (2024-08-26)
    # fenix = {
    #   url = "github:nix-community/fenix?ref=6c9f0709358f212766cff5ce79f6e8300ec1eb91";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # blocklist to add to hosts file -- stops ads and malware across apps
    sbhosts.url = "github:StevenBlack/hosts";

    # command line tool for gtm-hub
    gtm-okr.url = "github:zmre/gtm-okr";
    gtm-okr.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # twitter cli
    babble-cli.url = "github:zmre/babble-cli";
    babble-cli.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # devenv tool to simplify (?) project shells https://devenv.sh
    devenv.url = "github:cachix/devenv/v0.5";

    # Tool to make mac aliases without needing Finder scripting permissions for home-manager app linking
    mkalias.url = "github:reckenrode/mkalias";
    mkalias.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nps.url = "github:OleMussmann/Nix-Package-Search"; # use nps to quick search packages - requires gnugrep though
    nps.inputs.nixpkgs.follows = "nixpkgs";

    enola.url = "github:TheYahya/enola"; # sister to sherlock osint recon tool
    enola.flake = false;

    # VSCode extension built from github -- update version here and in ./modules/overlays.nix
    kubernetes-yaml-formatter.url = "github:longkai/kubernetes-yaml-formatter/v1.1.0";
    kubernetes-yaml-formatter.flake = false;

    # github extensions not in nixpkgs (should periodically check that)
    gh-worktree.url = "github:zmre/gh-worktree";
    gh-worktree.inputs.nixpkgs.follows = "nixpkgs-unstable";
    gh-feed.url = "github:rsteube/gh-feed";
    gh-feed.flake = false;

    yazi.url = "github:sxyazi/yazi";
    yazi-quicklook.url = "github:vvatikiotis/quicklook.yazi";
    yazi-quicklook.flake = false;
    yazi-flavors.url = "github:yazi-rs/flavors";
    yazi-flavors.flake = false;

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";
    #nix-homebrew.inputs.brew-src.follows = "brew-src";
    nix-homebrew.inputs.nix-darwin.follows = "darwin";
    # Declarative, pinned homebrew tap management
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;
    homebrew-bundle.url = "github:homebrew/homebrew-bundle";
    homebrew-bundle.flake = false;
    # homebrew-cask-fonts.url = "github:homebrew/homebrew-cask-fonts";
    # homebrew-cask-fonts.flake = false;
    homebrew-services.url = "github:homebrew/homebrew-services";
    homebrew-services.flake = false;
    homebrew-cask-drivers.url = "github:homebrew/homebrew-cask-drivers"; # for flipper zero
    homebrew-cask-drivers.flake = false;
    # homebrew-trippy.url = "github:fujiapple852/trippy"; # for trippy ping util
    # homebrew-trippy.flake = false;
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-stable-darwin,
    nixpkgs-unstable,
    darwin,
    home-manager,
    sbhosts,
    nixos-hardware,
    nix-homebrew,
    ...
  }: let
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        inherit
          (import ./modules/overlays.nix {
            inherit inputs nixpkgs-unstable nixpkgs-stable nixpkgs-stable-darwin;
          })
          overlays
          ;
        config = import ./config.nix;
      };

    mkHome = username: modules: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = {inherit inputs username;};
        users."${username}".imports = modules;
      };
    };
  in {
    darwinConfigurations = let
      username = "pwalsh";
    in {
      attolia = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = mkPkgs "aarch64-darwin";
        specialArgs = {
          inherit sbhosts inputs nixpkgs-stable nixpkgs-stable-darwin nixpkgs-unstable username;
        };
        modules = [
          nix-homebrew.darwinModules.nix-homebrew # Make it so I can pin my homebrew taps and actually roll things back
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = false;

              # User owning the Homebrew prefix
              user = username;

              # Declarative tap management
              taps = with inputs; {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                # "homebrew/homebrew-cask-fonts" = homebrew-cask-fonts;
                "homebrew/homebrew-bundle" = homebrew-bundle;
                "homebrew/homebrew-services" = homebrew-services;
                "homebrew/homebrew-cask-drivers" = homebrew-cask-drivers;
                # "fujiapple852/trippy" = homebrew-trippy;
              };

              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              mutableTaps = false;

              # should only need this once...
              autoMigrate = false;
            };
          }
          ./modules/darwin
          home-manager.darwinModules.home-manager
          (mkHome username [
            ./modules/home-manager
            ./modules/home-manager/home-darwin.nix
            ./modules/home-manager/home-security.nix
          ])
        ];
      };
    };

    nixosConfigurations = let
      username = "zmre";
    in {
      nixos = nixpkgs-unstable.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = mkPkgs "aarch64-linux";
        specialArgs = {inherit inputs username;};
        modules = [
          home-manager.nixosModules.home-manager
          ./modules/hardware/parallels-arm.nix
          {
            networking.hostName = "nixos"; # Define your hostname.
          }
          ./modules/nixos
          #./modules/hardware/parallels.nix
          sbhosts.nixosModule
          {networking.stevenBlackHosts.enable = true;}
          (mkHome username [
            ./modules/home-manager
            ./modules/home-manager/home-linux.nix
          ])
        ];
      };
      volantis = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = mkPkgs "x86_64-linux";
        specialArgs = {
          inherit
            sbhosts
            inputs
            nixpkgs
            nixpkgs-stable
            nixpkgs-unstable
            username
            ;
        };
        modules = [
          ./modules/hardware/framework-volantis.nix
          ./modules/hardware/volantis.nix
          nixos-hardware.nixosModules.framework-11th-gen-intel
          ./modules/nixos
          sbhosts.nixosModule
          {networking.stevenBlackHosts.enable = true;}
          home-manager.nixosModules.home-manager
          (mkHome username [
            ./modules/home-manager
            ./modules/home-manager/home-linux.nix
            ./modules/home-manager/home-security.nix
          ])
        ];
      };
      nixos-pw-vm = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = mkPkgs "x86_64-linux";
        specialArgs = {inherit inputs username;};
        modules = [
          home-manager.nixosModules.home-manager
          ./modules/nixos
          ./modules/hardware/parallels-hardware.nix
          ./modules/hardware/parallels.nix
          sbhosts.nixosModule
          {networking.stevenBlackHosts.enable = true;}
          (mkHome username [
            ./modules/home-manager
            ./modules/home-manager/home-linux.nix
          ])
        ];
      };
    };
  };
}
