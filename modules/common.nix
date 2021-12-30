{ inputs, config, lib, pkgs, nixpkgs, stable, ... }: {
  imports = [ ./primary.nix ./nixpkgs.nix ./overlays.nix ];

  time.timeZone = "America/Denver";
  services.timesyncd.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  # suggest install package if cmd missing
  programs.command-not-found.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };

  user = {
    description = "Patrick Walsh";
    home = "${
        if pkgs.stdenvNoCC.isDarwin then "/Users" else "/home"
      }/${config.user.name}";
    shell = pkgs.zsh;
  };

  # bootstrap home manager using system config
  hm = import ./home-manager;

  # let nix manage home-manager profiles and use global nixpkgs
  home-manager = {
    extraSpecialArgs = { inherit inputs lib; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };

  # environment setup
  environment = {
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${nixpkgs}";
      stable.source = "${stable}";
      #trunk.source = "${inputs.trunk}";
      #small.source = "${inputs.small}";
    };
    # list of acceptable shells in /etc/shells
    shells = with pkgs.stable; [ bash zsh ];
  };

  environment.sessionVariables = {
    LANGUAGE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
  environment.pathsToLink = [ "/libexec" ];
}
