{ config, lib, pkgs, ... }: {
  homebrew = {
    casks = [
      "bartender"
      "gpg-suite"
      "iina"
      "choosy"
      "lockrattler"
      "marked"
      "mpv"
      "zoom"
      "qlmarkdown"
      "qlprettypatch"
      "qlstephen"
      "qlvideo"
      "quicklook-json"
      "revisionist"
      "silentknight"
      "reikey"
      "blockblock"
      "transmission"
      "xbar"
      "zenmap"
      "systhist"
      "owasp-zap"
      "burp-suite"
      "paw"
      "font-dejavu-sans-mono-nerd-font"
      "font-droid-sans-mono-nerd-font"
      "font-fira-code-nerd-font"
      "font-fira-mono-nerd-font"
      "font-hack-nerd-font"
      "font-hasklug-nerd-font"
      "font-meslo-lg-nerd-font"
    ];
    masApps = {
      "Monodraw" = 920404675;
      "Yubico Authenticator" = 1497506650;
      "PCalc" = 403504866;
      "WireGuard" = 1451685025;
      "Forecast Bar" = 982710545;
      "Kaleidoscope" = 587512244;
    };
  };
}
