{
  description = "Security tools";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };
        #let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = import ./shell.nix { inherit pkgs; };
        defaultPackage.${system} = import ./shell.nix { inherit pkgs; };
      });
}
