{
  description = "zmre nix cross-platform system configurations";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # gitstatus is required by powerlevel10k
    gitstatus.url = "github:romkatv/gitstatus";
    gitstatus.flake = false;

    # gives me a prompt that is async and fast
    powerlevel10k.url = "github:romkatv/powerlevel10k";
    powerlevel10k.flake = false;

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
  };

  outputs = inputs@{ self, nixpkgs-stable, nixpkgs-unstable, darwin
    , home-manager, sbhosts, ... }:
    let
      inherit (home-manager.lib) homeManagerConfiguration;

      mkPkgs = system:
        import nixpkgs-unstable {
          inherit system;
          inherit (import ./modules/overlays.nix {
            inherit inputs nixpkgs-unstable nixpkgs-stable;
          })
            overlays;
          config = import ./config.nix;
        };

      mkHome = username: modules: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";
          extraSpecialArgs = { inherit inputs; };
          users."${username}".imports = modules;
        };
      };

    in {

      darwinConfigurations = {
        attolia = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = mkPkgs "aarch64-darwin";
          specialArgs = {
            inherit sbhosts inputs nixpkgs-stable nixpkgs-unstable;
            username = "pwalsh";
          };
          modules = [
            ./modules/darwin
            home-manager.darwinModules.home-manager
            { homebrew.brewPrefix = "/opt/homebrew/bin"; }
            (mkHome "pwalsh" [
              ./modules/home-manager
              ./modules/home-manager/home-darwin.nix
              # ./modules/home-manager/home-security.nix
            ])
          ];
        };
      };

      nixosConfigurations = {
        volantis = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = mkPkgs "x86_64-linux";
          specialArgs = {
            inherit inputs;
            username = "zmre";
          };
          modules = [
            home-manager.nixosModules.home-manager
            ./modules/nixos
            ./modules/hardware/framework-volantis.nix
            ./modules/hardware/volantis.nix
            ./profiles/zmre.nix
            sbhosts.nixosModule
            { networking.stevenBlackHosts.enable = true; }
            (mkHome "zmre" [
              ./modules/home-manager
              ./modules/home-manager/home-linux.nix
              ./modules/home-manager/home-security.nix
            ])
          ];
        };
        nixos-pw-vm = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = mkPkgs "x86_64-linux";
          specialArgs = {
            inherit inputs;
            username = "zmre";
          };
          modules = [
            home-manager.nixosModules.home-manager
            ./modules/nixos
            ./modules/hardware/parallels-hardware.nix
            ./modules/hardware/parallels.nix
            sbhosts.nixosModule
            { networking.stevenBlackHosts.enable = true; }
            (mkHome "zmre" [
              ./modules/home-manager
              ./modules/home-manager/home-linux.nix
            ])
          ];
        };
      };
    };
}
