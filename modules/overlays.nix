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
        nix.package = inputs.nixos-stable.nix_2_4;
      };
      #trunk = import inputs.trunk { system = prev.system; };
      #small = import inputs.small { system = prev.system; };
      # from malob's config

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
      hackernews-tui = prev.rustPlatform.buildRustPackage {
        name = "hackernews-tui";
        pname = "hackernews-tui";
        cargoLock = { lockFile = inputs.hackernews-tui + /Cargo.lock; };
        buildDependencies = [ prev.glib ];
        buildInputs = [ prev.pkg-config ]
          ++ prev.lib.optionals prev.stdenv.isDarwin
          [ prev.darwin.apple_sdk.frameworks.Security ];
        src = inputs.hackernews-tui;
      };
    })
    inputs.nur.overlay

  ];
}
