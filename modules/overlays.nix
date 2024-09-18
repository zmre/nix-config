{
  inputs,
  nixpkgs-stable,
  nixpkgs-stable-darwin,
  ...
}: {
  overlays = [
    # channels
    (final: prev: {
      # expose other channels via overlays
      stable =
        if prev.stdenv.isDarwin
        then
          import nixpkgs-stable-darwin {
            inherit (prev) system;
            config = import ../config.nix;
            #nix.package = inputs.nixos-stable.nixVersions.nix_2_11;
            nix.package = inputs.nixos-stable.nix;
          }
        else
          import nixpkgs-stable {
            inherit (prev) system;
            config = import ../config.nix;
            #nix.package = inputs.nixos-stable.nixVersions.nix_2_11;
            nix.package = inputs.nixos-stable.nix;
          };
    })
    (final: prev: {
      enola = prev.buildGo123Module {
        # TODO: this seems to be failing with this problem https://discourse.nixos.org/t/cant-update-a-go-package-getting-go-inconsistent-vendoring/27063/6
        # But I don't have time to figure out how to fix it right now 2024-09-11
        name = "enola";
        pname = "enola";
        src = inputs.enola;
        # just have to manually update this each time it fails, I guess
        # vendorSha256 = prev.lib.fakeSha256;
        vendorHash = "sha256-UA4AoO9yDgufZrABJImo+580aaye4jp7qRevj3Efkrg=";
      };
    })
    (final: prev: {
      # Purpose of this is to add the impersonation features from curl-impersonate to get around cloudflare block and others
      # See https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#impersonation
      # So far I'm failing and will probably just use the version from brew, which has the impersonation features
      yt-dlp =
        (prev.yt-dlp.overridePythonAttrs (oldAttrs: {
          optional-dependencies = {
            curl-cffi = [prev.python3Packages.curl-cffi];
          };
          dependencies = oldAttrs.dependencies ++ [prev.python3Packages.curl-cffi];
        }))
        .overrideAttrs (oldAttrs: {
          buildInputs = oldAttrs.buildInputs ++ [prev.python3Packages.curl-cffi];
        });
    })
    (final: prev: {
      zsh-fzf-tab = prev.zsh-fzf-tab.overrideAttrs (
        oldAttrs: let
          INSTALL_PATH = "${placeholder "out"}/share/fzf-tab";
        in {
          installPhase = ''
            mkdir -p ${INSTALL_PATH}
            cp -r lib ${INSTALL_PATH}/lib
            install -D fzf-tab.zsh ${INSTALL_PATH}/fzf-tab.zsh
            install -D fzf-tab.plugin.zsh ${INSTALL_PATH}/fzf-tab.plugin.zsh
            # install -D modules/Src/aloxaf/fzftab.so ${INSTALL_PATH}/modules/Src/aloxaf/fzftab.so
          '';
        }
      );
    })
    (final: prev: {
      kubernetes-yaml-formatter = prev.vscode-utils.buildVscodeExtension {
        name = "kubernetes-yaml-formatter";
        src = inputs.kubernetes-yaml-formatter;
        vscodeExtUniqueId = "kennylong.kubernetes-yaml-formatter";
        vscodeExtPublisher = "kennylong";
        vscodeExtName = "kubernetes-yaml-formatter";
        version = "1.1.0";
      };
    })
    (final: prev: {
      hackernews-tui = let
        inherit (inputs.fenix.packages.${prev.system}.stable) toolchain;
      in
        (prev.makeRustPlatform {
          cargo = toolchain;
          rustc = toolchain;
        })
        .buildRustPackage {
          name = "hackernews-tui";
          pname = "hackernews-tui";
          cargoLock = {lockFile = inputs.hackernews-tui + /Cargo.lock;};
          # buildDependencies = [prev.glib];
          buildInputs =
            [prev.pkg-config prev.libiconv]
            ++ prev.lib.optionals prev.stdenv.isDarwin
            [prev.darwin.apple_sdk.frameworks.Security];
          src = inputs.hackernews-tui;
        };
    })
    (final: prev: {
      # qutebrowser = prev.qutebrowser.override {
      #   nativeBuildInputs = prev.qutebrowser.nativeBuildInputs ++ prev.lib.optionals prev.stdenv.isDarwin
      #     [ prev.darwin.apple_sdk.frameworks.Security ]; #darwin.cctools
      # };
      tickrs = prev.tickrs.overrideAttrs (oldAttrs: {
        buildInputs =
          oldAttrs.buildInputs
          ++ prev.lib.optionals prev.stdenv.isDarwin
          [prev.darwin.apple_sdk.frameworks.SystemConfiguration];
      });
    })
    (final: prev: {
      inherit (inputs.gtm-okr.packages.${final.system}) gtm-okr;
      inherit (inputs.babble-cli.packages.${final.system}) babble-cli;
      inherit (inputs.mkalias.packages.${final.system}) mkalias;
      inherit (inputs.ironhide.packages.${final.system}) ironhide;
      inherit (inputs.pwnvim.packages.${final.system}) pwnvim;
      inherit (inputs.pwneovide.packages.${final.system}) pwneovide;
      inherit (inputs.nps.packages.${final.system}) nps;
      inherit (inputs.devenv.packages.${final.system}) devenv;
    })
    (final: prev: {
      inherit (inputs.gh-worktree.packages.${final.system}) gh-worktree;
      gh-feed = prev.buildGoModule {
        pname = "gh-feed";
        name = "gh-feed";
        doCheck = false;
        src = inputs.gh-feed;
        # just have to manually update this each time it fails, I guess
        # vendorHash = prev.lib.fakeHash;
        vendorHash = "sha256-IFSu4MC/vntxRsg2G7e70lXe1aCRTmpRQt0JPXWabQA=";
      };
    })
    inputs.nur.overlay
  ];
}
