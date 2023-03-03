{
  description = "zmre nix cross-platform system configurations";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # defaulting to unstable these days

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # I use the nur repo for firefox extensions
    nur.url = "github:nix-community/NUR";

    # Need fenix to specify rustc version -- specifically for hackernews-tui
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    pwnvim.url = "github:zmre/pwnvim";
    pwneovide.url = "github:zmre/pwneovide";

    ironhide.url = "github:IronCoreLabs/ironhide?ref=1.0.5";
    hackernews-tui.url = "github:aome510/hackernews-TUI";
    hackernews-tui.flake = false;

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
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-unstable,
    darwin,
    home-manager,
    sbhosts,
    nixos-hardware,
    ...
  }: let
    inherit (home-manager.lib) homeManagerConfiguration;

    mkPkgs = system:
      import nixpkgs {
        inherit system;
        inherit
          (import ./modules/overlays.nix {
            inherit inputs nixpkgs-unstable nixpkgs-stable;
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
          inherit sbhosts inputs nixpkgs-stable nixpkgs-unstable username;
        };
        modules = [
          ./modules/darwin
          home-manager.darwinModules.home-manager
          {homebrew.brewPrefix = "/opt/homebrew/bin";}
          (mkHome username [
            ./modules/home-manager
            ./modules/home-manager/home-darwin.nix
            # ./modules/home-manager/home-security.nix
          ])
        ];
      };
    };

    nixosConfigurations = let
      username = "zmre";
    in {
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
          nixos-hardware.nixosModules.framework
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
