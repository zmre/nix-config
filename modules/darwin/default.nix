{ pkgs, config, username, nixpkgs-stable, nixpkgs-unstable, ... }: {
  time.timeZone = "America/Denver";
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };

  # environment setup
  environment = {
    etc = {
      nixpkgs.source = "${nixpkgs-unstable}";
      stable.source = "${nixpkgs-stable}";
    };
    # list of acceptable shells in /etc/shells
    shells = with pkgs; [ bash zsh ];
    pathsToLink = [ "/libexec" ];
  };

  nix = {
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      "experimental-features = nix-command flakes"}
    '';
    settings = {
      sandbox = true;
      trusted-users = [ "${username}" "root" "@admin" "@wheel" ];
      max-jobs = 8;
      cores = 0; # use them all
      allowed-users = [ "@wheel" ];
    };
    #autoOptimiseStore = true;
    #optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    readOnlyStore = true;

  };

  imports = [
    ./pam.nix # enableSudoTouchIdAuth is now in nix-darwin, but without the reattach stuff for tmux
    ./core.nix
    ./brew.nix
    ./preferences.nix
  ];
}
