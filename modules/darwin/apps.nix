{ config, lib, pkgs, ... }: {
  homebrew = {
    casks = [
      #"bartender"
      "blockblock"
      "choosy"
      "font-dejavu-sans-mono-nerd-font"
      "font-droid-sans-mono-nerd-font"
      "font-fira-code-nerd-font"
      "font-fira-mono-nerd-font"
      "font-hasklug-nerd-font"
      "font-inconsolata-nerd-font"
      "font-meslo-lg-nerd-font"
      "gpg-suite"
      "iina"
      "lockrattler"
      "marked"
      "mpv"
      "owasp-zap"
      "qutebrowser"
      "qlmarkdown"
      "qlprettypatch"
      "qlstephen"
      "qlvideo"
      "quicklook-csv"
      "quicklook-json"
      "quicklookase"
      "reikey"
      "revisionist"
      "silentknight"
      "systhist"
      "transmission"
      "webpquicklook"
      "wireshark-chmodbpf"
      "xbar"
      "zenmap"
      "zoom"
      #"burp-suite"
      #"paw"
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
