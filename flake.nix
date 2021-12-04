{
  description = "zmre system configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    unstable.url = "nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    comma = {
      url = "github:Shopify/comma";
      flake = false;
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, nur, darwin, home-manager, unstable, flake-utils, ... }:
    let
      #system = "x86_64-linux";
      pkgs = import nixpkgs {
        #inherit system;
        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;

    in {

      #packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

      #defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

      nixosConfigurations = {
        nixos-pw-vm = lib.nixosSystem {
          #inherit system;
          system = "x86_64-linux";
          modules = [ ./machines/parallels.nix ];
        };
        volantis = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./machines/framework.nix ];
        };
      };

      darwinConfigurations.dragonstone = darwin.lib.darwinSystem {
        inherit pkgs;
        system = "x86_64-darwin";
        modules = [ ]; # TODO
      };
      homeManagerConfigurations = {
        zmre = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          system = "x86_64-linux";
          username = "zmre";
          homeDirectory = "/home/zmre";
          configuration = { imports = [ ./home.nix ]; };
        };
      };
    };
}
