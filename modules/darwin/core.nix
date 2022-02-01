{ inputs, config, pkgs, ... }:
let prefix = "/run/current-system/sw/bin";
in {
  # environment setup
  environment = {
    loginShell = pkgs.zsh;
    pathsToLink = [ "/Applications" ];
    #backupFileExtension = "backup";
    etc = { darwin.source = "${inputs.darwin}"; };
    # Use a custom configuration.nix location.
    # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix

    # packages installed in system profile
    systemPackages = with pkgs; [ git curl coreutils gnused ];
  };

  # Just configure DNS for WiFi for now
  networking.knownNetworkServices = [ "Wi-Fi" ];
  networking.dns = [ "1.1.1.1" "1.0.0.1" ];

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  fonts.enableFontDir =
    false; # if this is true, manually installed fonts will be deleted!
  fonts.fonts = with pkgs; [
    powerline-fonts
    source-code-pro
    nerdfonts
    vegur
    noto-fonts
  ];
  nix.nixPath = [ "darwin=/etc/${config.environment.etc.darwin.target}" ];
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # auto manage nixbld users with nix darwin
  users.nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # allow touchid to auth sudo -- this comes from pam.nix, which needs to be loaded before this
  security.pam.enableSudoTouchIdAuth = true;

}
