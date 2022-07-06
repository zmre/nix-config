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
      #trunk = import inputs.trunk { system = prev.system; };
      #small = import inputs.small { system = prev.system; };
      # from malob's config

      # Aborted attempt to fix https://github.com/NixOS/nixpkgs/pull/179159
      # python3Packages = (prev.python3.override {
      #   packageOverrides = _:
      #     { urllib3, ... }: {
      #       urllib3 = urllib3.overrideAttrs
      #         ({ passthru, propagatedBuildInputs, ... }: {
      #           passthru = passthru // {
      #             optional-dependencies =
      #               prev.lib.filterAttrs (n: _v: n != "secure")
      #               (passthru.optional-dependencies or [ ]);
      #           };
      #           propagatedBuildInputs = propagatedBuildInputs
      #             // (passthru.optional-dependencies.brotli or [ ]);
      #         });
      #     };
      # }).pkgs;

      # Overlay that adds some additional Neovim plugins
      vimPlugins = prev.vimPlugins // {
        vim-roam-task = prev.vimUtils.buildVimPluginFrom2Nix {
          name = "vim-roam-task";
          pname = "vim-roam-task";
          src = inputs.vim-roam-task;
        };
        telescope-media-files = prev.vimUtils.buildVimPlugin {
          name = "telescope-media-files";
          pname = "telescope-media-files";
          src = inputs.telescope-media-files;
        };
        zk-nvim = prev.vimUtils.buildVimPlugin {
          name = "zk-nvim";
          pname = "zk-nvim";
          src = inputs.zk-nvim;
        };
      };
      # hackernews-tui = prev.rustPlatform.buildRustPackage {
      hackernews-tui = (prev.makeRustPlatform {
        inherit (inputs.fenix.packages.${prev.system}.minimal) cargo rustc;
      }).buildRustPackage {
        name = "hackernews-tui";
        pname = "hackernews-tui";
        cargoLock = { lockFile = inputs.hackernews-tui + /Cargo.lock; };
        buildDependencies = [ prev.glib ];
        buildInputs = [ prev.pkg-config ]
          ++ prev.lib.optionals prev.stdenv.isDarwin
          [ prev.darwin.apple_sdk.frameworks.Security ];
        src = inputs.hackernews-tui;
      };
      # qutebrowser = prev.qutebrowser.override {
      #   nativeBuildInputs = prev.qutebrowser.nativeBuildInputs ++ prev.lib.optionals prev.stdenv.isDarwin
      #     [ prev.darwin.apple_sdk.frameworks.Security ]; #darwin.cctools
      # };
      gtm-okr = inputs.gtm-okr.packages.${final.system}.gtm-okr;
      babble-cli = inputs.babble-cli.packages.${final.system}.babble-cli;

    })
    inputs.nur.overlay
  ];
}
