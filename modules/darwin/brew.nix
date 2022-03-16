{ inputs, config, pkgs, ... }: {
  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup =
      "uninstall"; # should maybe be "zap" - remove anything not listed here
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
      "homebrew/cask-drivers" # for flipper zero
    ];

    casks = [
      "adobe-creative-cloud"
      "amethyst" # for window tiling -- I miss chunkwm but it's successor, yabai, was unstable.
      "audio-hijack"
      # Backblaze just adds the Backblaze Installer to the caskroom. Doesn't link it. Worthless.
      #"backblaze"
      "bartender" # organize status bar
      "blockblock"
      "brave-browser"
      "canon-eos-utility"
      "canon-eos-webcam-utility"
      "choosy" # multi-browser url launch selector
      "dash" # offline developer docs
      "default-folder-x"
      "discord"
      "docker"
      "dropbox"
      "firefox"
      "gpg-suite"
      "imageoptim"
      "karabiner-elements"
      "little-snitch"
      "lockrattler"
      "loopback"
      "marked"
      "microsoft-office"
      "mpv"
      "noun-project"
      "obs"
      "parallels"
      "protonmail-bridge"
      #"qflipper" # TODO: add this back when their site is back up
      "qutebrowser"
      "qlmarkdown"
      "qlprettypatch"
      "qlvideo"
      "quicklookase"
      "reikey"
      "raycast"
      "signal"
      "silentknight"
      "silnite"
      "skype"
      "spotify"
      "superhuman"
      "sync"
      "syncthing"
      "textexpander"
      "ticktick"
      "tor-browser"
      "transmission"
      "webpquicklook"
      "wireshark-chmodbpf"
      "xbar"
      "yubico-yubikey-manager"
      "zenmap"
      "zoom"
      # would be better to load these in a security shell, but nix versions don't build on mac
      "owasp-zap"
      "burp-suite"
      #"paw"
    ];

    masApps = {
      "Brother iPrint&Scan" = 1193539993;
      "Monodraw" = 920404675; # ASCII drawings
      "Yubico Authenticator" = 1497506650;
      "PCalc" = 403504866;
      "WireGuard" = 1451685025; # VPN
      "Forecast Bar" = 982710545;
      "Kaleidoscope" = 587512244; # GUI 3-way merge
      "iMovie" = 408981434;
      "Blurred" = 1497527363; # dim non-foreground windows
      "Save to Pocket" = 1477385213;
      "Fantastical" = 975937182;
      "DaisyDisk" = 411643860;
      "Tweetbot" = 1384080005;
      "Disk Speed Test" = 425264550;
      "Endel" = 1484348796;
      #"Wipr" = 1320666476;
      "Ghostery – Privacy Ad Blocker" = 1436953057;
      "Cardhop" = 1290358394;
      "Strongbox" = 1270075435;
      "Pocket" = 568494494;
      "Slack" = 803453959;
      "Kindle" = 405399194;
      "Scrivener" = 1310686187;
      "Keynote" = 409183694;
      "Vinegar" = 1591303229;
      "PeakHour" = 1241445112;
      "StopTheMadness" = 1376402589;
      "Amphetamine" = 937984704;
      "Vimari" = 1480933944;
      "Xcode" = 497799835;
      "iStumbler" = 546033581;
    };
    brews = [
      "pam-reattach"
      "brightness"
      "ciphey"
      "ca-certificates"
      "dashing" # generate dash docs from html
      "ddcctl"
      "ansiweather"
      "feroxbuster" # dirbuster in rust; not in nixpkgs yet
      "findutils" # TODO: needed?
      "gdrive"
      "ical-buddy"
      "ncspot"
      "chkrootkit"
      # because the nix recipe isn't compiling on darwin
      "lua-language-server"
      # would rather load these as part of a security shell, but...
      "p0f" # the nix one only builds on linux
      "hashcat" # the nix one only builds on linux
      "hydra" # the nix one only builds on linux
    ];
  };
}

############## to revisit
#clamav
#cocoapods
#dnscrypt-proxy
#dnscrypt-wrapper
#dnsmasq
#elinks
#fasd
#gh
#httpry
#hub
#links
#lnav
#lynx
#multimarkdown
#net-snmp
#ossp-uuid
#p7zip
#yubico-piv-tool
#pdf2json
#pdftohtml
#procs
#proxmark3
#recon-ng # not currently available on nix?

############### to examine
#qpdf
#qprint
#qrencode
#rav1e
#readline
#reaver
#recode
#ripmime
#rtmpdump
#rubberband
#rustscan
#s-lang
#salty
#sane-backends
#sbt
#scala
#scalariform
#scalastyle
#scons
#scrub
#sdl2
#sdl2_image
#serf
#shared-mime-info
#shellcheck
#silicon
#sip
#sipsak
#six
#sk
#sleuthkit
#snappy
#sntop
#so
#soapyrtlsdr
#soapysdr
#socat
#spark
#speedtest-cli
#speedtest_cli
#speex
#sphinx-doc
#spidermonkey
#spotify-tui
#spotifyd
#sqlite
#sqlmap
#srt
#ssdeep
#ssldump
#sslscan
#sslyze
#starship
#stoken
#stunnel
#svg2pdf
#svg2png
#swiftformat
#swiftlint
#swig
#szip
#tag
#talloc
#task
#tasksh
#taskwarrior-tui
#tcl-tk
#tcpflow
#tcping
#tcpstat
#tcptrace
#tcptraceroute
#telnet
#terminal-notifier
#tesseract
#testssl
#texi2html
#the_platinum_searcher
#the_silver_searcher
#theharvester
#theora
#tidy-html5
#tig
#tika
#timewarrior
#tmux
#tokyo-cabinet
#torsocks
#ttfautohint
#ttyplot
#ubertooth
#uchardet
#uhd
#unbound
#unibilium
#unison
#unixodbc
#unpaper
#urlview
#usbmuxd
#utf8proc
#vapoursynth
#vde
#vifm
#vips
#virtual
#volatility
#volk
#w3m
#wabt
#wakeonlan
#watch
#webp
#weechat
#wget
#wireguard-go
#wireshark
#wxmac
#wxpython
#wxwidgets
#x264
#x265
#xapian
#xdelta
#xh
#xml2
#xmlto
#xorgproto
#xplr
#xvid
#xz
#yabai
#yara
#yarn
#yasm
#ykman
#ykpers
#yq
#yt-dlp
#ytop
#yuicompressor
#zeek
#zenith
#zeromq
#zimg
#zlib
#zmap
#zoxide
#zsh
#zstd
#amethyst
#armitage
#blockblock
#boostnote
#cakebrew
#choosy
#dmenu-mac
#font-bitstream-vera-sans-mono-nerd-font
#font-code-new-roman-nerd-font
#font-dejavu-sans-mono-nerd-font
#font-droid-sans-mono-nerd-font
#font-fira-code-nerd-font
#font-fira-mono-nerd-font
#font-hack-nerd-font
#font-hasklug-nerd-font
#font-inconsolata-nerd-font
#font-jetbrains-mono-nerd-font
#font-meslo-lg-nerd-font
#font-mononoki-nerd-font
#font-profont-nerd-font
#font-proggy-clean-tt-nerd-font
#font-roboto-mono-nerd-font
#font-space-mono-nerd-font
#font-ubuntu-mono-nerd-font
#font-ubuntu-nerd-font
#gas-mask
#gcc-arm-embedded
#gitkraken
#gitup
#goneovim
#graphql-playground
#gswitch
#hammerspoon
#iina
#isteg
#keepassxc
#kitty
#macdown
#osxfuse
#pacifist
#powershell
#transmission
#tunnelblick
#vulkan-sdk
#wkhtmltopdf
#zenmap
