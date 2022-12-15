{ inputs, nixpkgs, stable, ... }: {
  nixpkgs.overlays = [
    # channels
    (final: prev: {
      # expose other channels via overlays
      stable = import stable {
        system = prev.system;
        config.allowUnfree = true;
        config.allowBroken = true;
        config.allowUnsupportedSystem = true;
        nix.package = inputs.nixos-stable.nix_2_8;
      };

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
      # qutebrowser = prev.qutebrowser.override {
      #   nativeBuildInputs = prev.qutebrowser.nativeBuildInputs ++ prev.lib.optionals prev.stdenv.isDarwin
      #     [ prev.darwin.apple_sdk.frameworks.Security ]; #darwin.cctools
      # };
      tickrs = prev.tickrs.overrideAttrs (oldAttrs: rec {
        buildInputs = oldAttrs.buildInputs
          ++ [ prev.darwin.apple_sdk.frameworks.SystemConfiguration ];
      });
      gtm-okr = inputs.gtm-okr.packages.${final.system}.gtm-okr;
      babble-cli = inputs.babble-cli.packages.${final.system}.babble-cli;
      ironhide = inputs.ironhide.packages.${final.system}.ironhide;
      pwnvim = inputs.pwnvim.packages.${final.system}.pwnvim;
      pwneovide = inputs.pwneovide.packages.${final.system}.pwneovide;
      nps = inputs.nps.defaultPackage.${final.system};
      # Damnit, switching to brew 2022-07-11
      # zk-latest = (prev.buildGoModule rec {
      #   name = "zk-latest";
      #   pname = "zk-latest";
      #   src = inputs.zk-latest;
      #   # Use below to get real value then paste below. I'm trying to find a workaround.
      #   #vendorSha256 = nixpkgs.lib.fakeSha256;
      #   #vendorSha256 = null; # not working :-(
      #   vendorSha256 = "sha256-11GzI3aEhKKTiULoWq9uIc66E3YCrW/HJQUYXRhCaek=";
      #   doCheck = false;
      #   buildInputs = [ prev.icu ];
      #   CGO_ENABLED = 1;
      #   ldflags = [ "-s" "-w" ]; # "-X=main.Build=${version}" ];
      # });
    })
    inputs.nur.overlay
  ];
}
