{
  description = "zmre system configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    unstable.url = "nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    flake-utils.url = "github:numtide/flake-utils";
    gitstatus.url = "github:romkatv/gitstatus";
    gitstatus.flake = false;
    powerlevel10k.url = "github:romkatv/powerlevel10k";
    powerlevel10k.flake = false;
  };

  outputs = inputs@{ self, ... }:
    with inputs.nixpkgs.lib;
    let
      forEachSystem = genAttrs [ "x86_64-linux" "x86_64-darwin" ];
      pkgsBySystem = forEachSystem (system:
        import inputs.nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = with inputs; [ nur.overlay ];
        });
    in {
      inherit pkgsBySystem;

      nixosConfigurations = {
        nixos-pw-vm = nixosSystem {
          system = "x86_64-linux";
          modules = [
            {
              nix = {
                package = pkgsBySystem."x86_64-linux".pkgs.nixFlakes;
                extraOptions = "experimental-features = nix-command flakes";
              };
            }
            {
              nixpkgs = {
                pkgs = pkgsBySystem."x86_64-linux";
                config.allowUnfree = true;
                overlays = with inputs; [ nur.overlay ];
              };
              # For compatibility with nix-shell, nix-build, etc.
              environment.etc.nixpkgs.source = inputs.nixpkgs;
            }
            ./machines/parallels.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.zmre = import ./home.nix;
              home-manager.extraSpecialArgs = inputs;
              home-manager.verbose = true;
            }
          ];
        };
        volantis = nixosSystem {
          system = "x86_64-linux";
          modules = [
            {
              nix = {
                package = pkgsBySystem."x86_64-linux".pkgs.nixFlakes;
                extraOptions = "experimental-features = nix-command flakes";
              };
            }
            {
              nixpkgs = {
                pkgs = pkgsBySystem."x86_64-linux";
                config.allowUnfree = true;
                overlays = with inputs; [ nur.overlay ];
              };
              # For compatibility with nix-shell, nix-build, etc.
              environment.etc.nixpkgs.source = inputs.nixpkgs;
            }
            ./machines/framework.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.zmre = import ./home.nix;
              home-manager.extraSpecialArgs = inputs;
            }
          ];
        };
      };

      darwinConfigurations.dragonstone = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          {
            nix = {
              package = pkgsBySystem."x86_64-darwing".pkgs.nixFlakes;
              extraOptions = "experimental-features = nix-command flakes";
            };
          }
          ./machines/darwin-configuration.nix
          {
            nixpkgs = {
              pkgs = pkgsBySystem."x86_64-darwin";
              config.allowUnfree = true;
            };
            # For compatibility with nix-shell, nix-build, etc.
            environment.etc.nixpkgs.source = inputs.nixpkgs;
          }
          home-manager.darwinModules.home-manager
          { home-manager.users.pwalsh = import ./home.nix; }
        ];
      };

      # homeManagerConfigurations = {
      #   zmre = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     system = "x86_64-linux";
      #     username = "zmre";
      #     homeDirectory = "/home/zmre";
      #     configuration = { imports = [ ./home.nix ]; };
      #   };
      # };
      #defaultPackage.x86_64-linux = debianSystem.activationPackage;
      defaultPackage.x86_64-darwin = darwinConfigurations.dragonstone.system;
    };
}
