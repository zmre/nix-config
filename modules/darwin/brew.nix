{ inputs, config, pkgs, ... }: {
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
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
      "fujiapple852/trippy"
    ];

    casks = [
      "adobe-creative-cloud"
      "amethyst" # for window tiling -- I miss chunkwm but it's successor, yabai, was unstable.
      #"audio-hijack"
      "bartender" # organize status bar
      "blockblock"
      "brave-browser" # TODO: move to home-manager when it builds
      "canon-eos-utility"
      #"canon-eos-webcam-utility"
      "choosy" # multi-browser url launch selector; see also https://github.com/johnste/finicky
      "dash" # offline developer docs
      "default-folder-x"
      "discord"
      "docker" # TODO: move to home-manager
      #"dropbox"
      # TODO: move espanso to home-manager
      "espanso" # text expander functionality (but open source donationware, x-platform, rust-based)
      "firefox" # TODO: firefox build is broken on ARM; check to see if fixed
      "fork"
      "gitify"
      "gpg-suite"
      "imageoptim"
      "insta360-studio"
      "istat-menus"
      "kindavim"
      "knockknock"
      "little-snitch"
      "lockrattler"
      #"loopback" -- haven't been using this of late
      "marked"
      #"microsoft-office" -- moved this to apple app store
      #"mpv"
      "noun-project"
      "obs" # TODO: move to nix version obs-studio when not broken
      "orion" # just trying out the Orion browser
      "parallels"
      "protonmail-bridge" # TODO: nix version now installs and works -- move over
      "qflipper"
      "qutebrowser" # TODO: move over when it builds on arm64 darwin
      "qlmarkdown"
      "qlstephen"
      #"qlprettypatch" # not updated in 9 years
      "qlvideo"
      #"quicklookase" # not updated in 6 years
      #"ripcord" # native (non-electron) desktop client for Slack + Discord -- try again in 2023
      "reikey"
      "raycast"
      "screenflow"
      "signal" # TODO: move to home-manager (signal-desktop) when not broken
      "silentknight"
      "silnite"
      "skype"
      "spotify" # TODO: move to home-manager when not broken
      "swiftdefaultappsprefpane"
      "sync"
      "syncthing" # TODO: move to home-manager
      "tor-browser" # TODO: move to home-manager (tor-browser-bundle-bin) when it builds
      "transmission"
      "transmit" # for syncing folders with dropbox on-demand instead of using their broken software
      # why broken, you ask? well, they're using deprecated APIs for one thing
      # their sync service is constantly burning up CPU when nothing is touching their folder
      # and they install quicklook plugins that aren't optional and the adobe illustrator one
      # causes constant crashes whenever a folder or open/save dialog opens a folder with an 
      # illustrator file in it. i reported it almost 3 years ago and there's a long thread of
      # others complaining about the same problem. i'd be done with dropbox entirely if i could.
      #"webpquicklook" # not updated in 5 years
      #"xbar"
      #"yattee" # private youtube
      "yubico-yubikey-manager" # TODO: move to home-manager (yubikey-manager or yubikey-manager-qt)
      "zenmap"
      "zoom" # TODO: move to home-manager (zoom-us)
      "zotero" # TODO: move to home-manager?
      # would be better to load  hese in a security shell, but nix versions don't build on mac
      "owasp-zap" # TODO: move to home-manager?
      "burp-suite" # TODO: move to home-manager?
      #"warp" # 2022-11-10 testing some crazy new rust-based terminal
      "webex"
      "wireshark-chmodbpf"
    ];

    masApps = {
      "Amphetamine" = 937984704;
      "Apple Configurator 2" = 1037126344;
      "Blurred" = 1497527363; # dim non-foreground windows
      "Boxy SVG" = 611658502; # nice code-oriented visual svg editor
      "Brother iPrint&Scan" = 1193539993;
      "Cardhop" = 1290358394; # contacts alternative
      "DaisyDisk" = 411643860;
      "Disk Decipher" = 516538625;
      "Disk Speed Test" = 425264550;
      "Endel" = 1484348796;
      "Fantastical" = 975937182; # calendar alternative
      "Forecast Bar" = 982710545;
      "Ghostery – Privacy Ad Blocker" = 1436953057;
      "Gifox 2" = 1461845568; # For short animated gif screen caps
      "Kagi, Inc." = 1622835804; # Paid private search engine plugin for Safari
      "Kaleidoscope" = 587512244; # GUI 3-way merge
      "Keynote" = 409183694;
      "Keyshape" = 1223341056; # animated svg editor
      "Kindle" = 405399194;
      "Mastonaut" = 1450757574; # mastodon client i'm trying
      "Microsoft Excel" = 462058435;
      "Microsoft Word" = 462054704;
      "Microsoft PowerPoint" = 462062816;
      "Monodraw" = 920404675; # ASCII drawings
      "NextDNS" = 1464122853;
      "NotePlan 3" = 1505432629;
      #"OneDrive" = 823766827;
      "PCalc" = 403504866;
      "PeakHour" = 1241445112;
      "Pocket" = 568494494;
      "SQLPro Studio" = 985614903;
      "Save to Pocket" = 1477385213;
      "Scrivener" = 1310686187;
      "Slack" = 803453959;
      "StopTheMadness" = 1376402589;
      "Strongbox" = 1270075435;
      "Tweetbot" = 1384080005;
      "Vimari" = 1480933944;
      "Vinegar" = 1591303229;
      "WireGuard" = 1451685025; # VPN
      "Xcode" = 497799835;
      "Yubico Authenticator" = 1497506650;
      "iMovie" = 408981434;
      #"Wipr" = 1320666476;
    };
    brews = [
      "pam-reattach"
      "brightness"
      "ciphey"
      "ca-certificates"
      "dashing" # generate dash docs from html
      "ddcctl"
      "ansiweather"
      "findutils" # TODO: needed?
      "gdrive"
      "marp-cli" # convert markdown to html slides
      "ical-buddy"
      "ncspot" # TODO: move to home-manager
      "chkrootkit" # TODO: move to home-manager
      "trippy" # an mtr alternative
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
