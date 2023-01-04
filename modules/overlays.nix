{ inputs, nixpkgs-stable, ... }: {
  overlays = [
    # channels
    (final: prev: {
      # expose other channels via overlays
      stable = import nixpkgs-stable {
        inherit (prev) system;
        config = import ../config.nix;
        nix.package = inputs.nixos-stable.nixVersions.nix_2_11;
      };
    })
    (final: prev: {
      # hackernews-tui = prev.rustPlatform.buildRustPackage {
      hackernews-tui = (prev.makeRustPlatform {
        inherit (inputs.fenix.packages.${prev.system}.minimal) cargo rustc;
      }).buildRustPackage {
        name = "hackernews-tui";
        pname = "hackernews-tui";
        cargoLock = { lockFile = inputs.hackernews-tui + /Cargo.lock; };
        buildDependencies = [ prev.glib ];
        buildInputs = [ prev.pkg-config prev.libiconv ]
          ++ prev.lib.optionals prev.stdenv.isDarwin
          [ prev.darwin.apple_sdk.frameworks.Security ];
        src = inputs.hackernews-tui;
      };
    })
    (final: prev: {
      # qutebrowser = prev.qutebrowser.override {
      #   nativeBuildInputs = prev.qutebrowser.nativeBuildInputs ++ prev.lib.optionals prev.stdenv.isDarwin
      #     [ prev.darwin.apple_sdk.frameworks.Security ]; #darwin.cctools
      # };
      tickrs = prev.tickrs.overrideAttrs (oldAttrs: rec {
        buildInputs = oldAttrs.buildInputs
          ++ prev.lib.optionals prev.stdenv.isDarwin
          [ prev.darwin.apple_sdk.frameworks.SystemConfiguration ];
      });
    })
    (final: prev: {
      inherit (inputs.gtm-okr.packages.${final.system}) gtm-okr;
      inherit (inputs.babble-cli.packages.${final.system}) babble-cli;
      inherit (inputs.ironhide.packages.${final.system}) ironhide;
      inherit (inputs.pwnvim.packages.${final.system}) pwnvim;
      inherit (inputs.pwneovide.packages.${final.system}) pwneovide;
    })
    inputs.nur.overlay
  ];
}
