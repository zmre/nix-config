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
        # vim-roam-task = prev.vimUtils.buildVimPluginFrom2Nix {
        #   name = "vim-roam-task";
        #   pname = "vim-roam-task";
        #   src = inputs.vim-roam-task;
        # };
        # telescope-media-files = prev.vimUtils.buildVimPlugin {
        #   name = "telescope-media-files";
        #   pname = "telescope-media-files";
        #   src = inputs.telescope-media-files;
        # };
        # zk-nvim = prev.vimUtils.buildVimPlugin {
        #   name = "zk-nvim";
        #   pname = "zk-nvim";
        #   src = inputs.zk-nvim;
        # };
        # surround-nvim = prev.vimUtils.buildVimPlugin {
        #   name = "surround.nvim";
        #   pname = "surround.nvim";
        #   src = inputs.surround-nvim;
        # };
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
