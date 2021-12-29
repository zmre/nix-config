{ inputs, config, pkgs, ... }: {
  homebrew = {
    enable = true;
    autoUpdate = false;
    global = {
      brewfile = true;
      noLock = true;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/core"
      "homebrew/services"
      "koekeishiya/formulae"
    ];

    brews = [
      # should be able to manage chunkwm and skhd outside of brew
      #"yabai"
      #"skhd"
    ];
  };
}
