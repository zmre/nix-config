{
  # Ported my own settings into the framework made by
  # github:kclejeune/system

  description = "zmre nix cross-platform system configurations";

  nixConfig = {
    bash-prompt = "";
    bash-prompt-suffix = "(nixflake)#";
  };

  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    #nixos-hardware.url = "github:nixos/nixos-hardware";
    darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # gitstatus is required by powerlevel10k
    gitstatus.url = "github:romkatv/gitstatus";
    gitstatus.flake = false;
    # gives me a prompt that is async and fast
    powerlevel10k.url = "github:romkatv/powerlevel10k";
    powerlevel10k.flake = false;
    # burke's cool command chooser script
    comma.url = "github:nix-community/comma";
    comma.flake = false;
    # I use the nur repo for firefox extensions
    nur.url = "github:nix-community/NUR";
    # My extra nvim plugins -- setup in overlays
    zk-nvim = {
      url = "github:mickael-menu/zk-nvim";
      flake = false;
    };
    telescope-media-files = {
      url = "github:nvim-telescope/telescope-media-files.nvim";
      flake = false;
    };
    vim-roam-task = {
      url = "github:samgriesemer/vim-roam-task";
      flake = false;
    };
    hackernews-tui = {
      url = "github:aome510/hackernews-TUI";
      flake = false;
    };
    # blocklist to add to hosts file -- stops ads and malware across apps
    sbhosts.url = "github:StevenBlack/hosts";
    gtm-okr.url = "github:zmre/gtm-okr";
    gtm-okr.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, nixos-hardware
    , devshell, flake-utils, sbhosts, ... }:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (nixpkgs.lib) nixosSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      inherit (flake-utils.lib) eachDefaultSystem eachSystem;
      inherit (builtins) listToAttrs map;

      mkLib = nixpkgs: nixpkgs.lib.extend (final: prev: home-manager.lib);

      lib = (mkLib nixpkgs);

      isDarwin = system: (builtins.elem system lib.platforms.darwin);
      homePrefix = system: if isDarwin system then "/Users" else "/home";

      # generate a base darwin configuration with the
      # specified hostname, overlays, and any extraModules applied
      mkDarwinConfig = { system ? "x86_64-darwin", nixpkgs ? inputs.nixpkgs
        , stable ? inputs.darwin-stable, lib ? (mkLib nixpkgs), baseModules ? [
          home-manager.darwinModules.home-manager
          ./modules/darwin
        ], extraModules ? [ ] }:
        darwinSystem {
          inherit system;
          modules = baseModules ++ extraModules;
          specialArgs = { inherit inputs lib nixpkgs stable; };
        };

      # generate a base nixos configuration with the
      # specified overlays, hardware modules, and any extraModules applied
      mkNixosConfig = { system ? "x86_64-linux", nixpkgs ? inputs.nixpkgs
        , stable ? inputs.nixos-stable, lib ? (mkLib nixpkgs), hardwareModules
        , baseModules ? [
          home-manager.nixosModules.home-manager
          ./modules/nixos
        ], extraModules ? [ ] }:
        nixosSystem {
          inherit system;
          modules = baseModules ++ hardwareModules ++ extraModules;
          specialArgs = { inherit inputs lib nixpkgs stable; };
        };

      # generate a home-manager configuration usable on any unix system
      # with overlays and any extraModules applied
      mkHomeConfig = { username, system ? "x86_64-linux"
        , nixpkgs ? inputs.nixpkgs, stable ? inputs.nixos-stable
        , lib ? (mkLib nixpkgs), baseModules ? [
          ./modules/home-manager
          {
            home.sessionVariables = {
              NIX_PATH =
                "nixpkgs=${nixpkgs}:stable=${stable}\${NIX_PATH:+:}$NIX_PATH";
            };
          }
        ], extraModules ? [ ] }:
        homeManagerConfiguration rec {
          inherit system username;
          homeDirectory = "${homePrefix system}/${username}";
          extraSpecialArgs = { inherit inputs lib nixpkgs stable; };
          configuration = {
            imports = baseModules ++ extraModules ++ [ ./modules/overlays.nix ];
          };
        };
    in {
      checks = listToAttrs (
        # darwin checks
        (map (system: {
          name = system;
          value = {
            dragonstone =
              self.darwinConfigurations.dragonstone.config.system.build.toplevel;
          };
        }) lib.platforms.darwin) ++
        # linux checks
        (map (system: {
          name = system;
          value = {
            volantis =
              self.nixosConfigurations.volantis.config.system.build.toplevel;
            parallels = self.homeConfigurations.parallels.activationPackage;
          };
        }) lib.platforms.linux));

      darwinConfigurations = {
        # dragonstone-m1 = mkDarwinConfig {
        #   system = "aarch64-darwin";
        #   extraModules = [
        #     ./profiles/personal.nix
        #     ./modules/darwin/apps.nix
        #     { homebrew.brewPrefix = "/opt/homebrew/bin"; }
        #   ];
        # };
        dragonstone = mkDarwinConfig {
          system = "x86_64-darwin";
          extraModules = [
            ./profiles/pwalsh.nix
            {
              homebrew.brewPrefix = "/usr/local/bin";
            }
            # Can't use networking.extraHosts outside of NixOS, so this hack:
            {
              environment.etc.hosts.text = ''
                255.255.255.255	broadcasthost
                ::1				localhost
                fe80::1%lo0		localhost
                127.0.0.1⇥  ⇥   localhost
                127.0.0.1       dev1.ironcorelabs.com
                127.0.0.1       dev1.scrambledbits.org

                # Added by Docker Desktop
                # To allow the same kube context to work on the host and the container:
                127.0.0.1 kubernetes.docker.internal
                # End of section

              '' + builtins.readFile ("${sbhosts}/hosts");
            }
          ];
        };
      };

      nixosConfigurations = {
        volantis = mkNixosConfig {
          hardwareModules = [
            ./modules/hardware/framework-volantis.nix
            ./modules/hardware/volantis.nix
          ];
          extraModules = [
            ./profiles/zmre.nix
            sbhosts.nixosModule
            { networking.stevenBlackHosts.enable = true; }
          ];
        };
        nixos-pw-vm = mkNixosConfig {
          hardwareModules = [
            ./modules/hardware/parallels-hardware.nix
            ./modules/hardware/parallels.nix
            #nixos-hardware.nixosModules.lenovo-thinkpad-t460s
          ];
          extraModules = [
            ./profiles/zmre.nix
            sbhosts.nixosModule
            { networking.stevenBlackHosts.enable = true; }
          ];
        };
      };

      homeConfigurations = {
        dragonstone = mkHomeConfig {
          username = "pwalsh";
          system = "x86_64-darwin";
          extraModules = [ ./profiles/home-manager/personal.nix ];
        };
        volantis = mkHomeConfig {
          username = "zmre";
          extraModules = [ ./profiles/home-manager/personal.nix ];
        };
        # darwinServerM1 = mkHomeConfig {
        #   username = "kclejeune";
        #   system = "aarch64-darwin";
        #   extraModules = [ ./profiles/home-manager/personal.nix ];
        # };
        parallels = mkHomeConfig {
          username = "zmre";
          extraModules = [ ./profiles/home-manager/personal.nix ];
        };
      };
    } //
    # add a devShell to this flake
    eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            devshell.overlay
            (final: prev: {
              # expose stable packages via pkgs.stable
              stable = import inputs.nixos-stable {
                system = prev.system;
                config.allowUnfree = true;
                config.allowBroken = true;
                config.allowUnsupportedSystem = true;
              };
            })
          ];
        };
        nixBin = pkgs.writeShellScriptBin "nix" ''
          ${pkgs.nix_2_4}/bin/nix --option experimental-features "nix-command flakes" "$@"
        '';
      in {
        devShell = pkgs.devshell.mkShell {
          packages = [ nixBin pkgs.treefmt pkgs.nixfmt pkgs.stylua ];
        };
      });
}
