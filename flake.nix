{
  description = "colt nix cross-platform system configurations";

  nixConfig = {
    bash-prompt = "";
    bash-prompt-suffix = "(nixflake)#";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = inputs@{ self, darwin, nixpkgs, nixpkgs-stable, nixpkgs-unstable
    , home-manager, ... }:
    let
      username = "colt";
      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = {
          allowUnsupportedSystem = true;
          allowBroken = false;
          allowUnfree = true;
          experimental-features = "nix-command flakes";
          keep-derivations = true;
          keep-outputs = true;
        };
      };

      overlays = {
        # Overlays to add different versions `nixpkgs` into package set
        master = _: prev: {
          master = import nixpkgs {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        stable = _: prev: {
          stable = import nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        unstable = _: prev: {
          unstable = import nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        apple-silicon = _: prev:
          nixpkgs-unstable.lib.optionalAttrs
          (prev.stdenv.system == "aarch64-darwin") {
            # Add access to x86 packages system is running Apple Silicon
            pkgs-x86 = import inputs.nixpkgs-unstable {
              system = "x86_64-darwin";
              inherit (nixpkgsConfig) config;
            };
          };
      };
    in {

      darwinConfigurations = {
        breq = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            inherit (nixpkgsConfig) config;
            overlays = with overlays; [ master stable unstable apple-silicon ];
          };
          specialArgs = {
            inherit inputs darwin username nixpkgs-stable nixpkgs-unstable;
          };
          modules = [
            ./modules/darwin
            { homebrew.brewPrefix = "/opt/homebrew/bin"; }
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs darwin username nixpkgs-stable
                    nixpkgs-unstable;
                };
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bak";
                users.colt = {
                  imports = [
                    ./modules/home-manager
                    {
                      home.sessionVariables = {
                        NIX_PATH =
                          "nixpkgs=${nixpkgs-unstable}:stable=${nixpkgs-stable}\${NIX_PATH:+:}$NIX_PATH";
                      };
                    }
                  ];
                };
              };
            }
          ];
        };
      };
    };
}
