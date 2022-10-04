{ inputs, config, pkgs, ... }: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup =
        "uninstall"; # should maybe be "zap" - remove anything not listed here
    };
    global = { brewfile = true; };

    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/core"
      "homebrew/services"
      "koekeishiya/formulae"
      "homebrew/cask-drivers" # for flipper zero
    ];

    casks = [
      "amethyst" # for window tiling -- I miss chunkwm but it's successor, yabai, was unstable.
      "discord"
      "docker"
      "firefox"
      "imageoptim"
      "qlmarkdown"
      "qlvideo"
      "signal"
      "spotify"
      "zoom"
    ];

    masApps = {
      "Keynote" = 409183694;
      "Slack" = 803453959;
      "Xcode" = 497799835;
    };
    brews = [ "pam-reattach" "chkrootkit" ];
  };
}
