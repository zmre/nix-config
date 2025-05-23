{
  inputs,
  config,
  pkgs,
  ...
}: {
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "uninstall"; # should maybe be "zap" - remove anything not listed here
    };
    global = {
      brewfile = true;
      autoUpdate = false;
    };

    # Weird side-effect of using nix-homebrew pinning is that what's below needs to be duplicated in the flake
    # or possibly I can get rid of this...
    # but I think it needs to be the same, though I might have to activate the system with the new tap in the flake before adding it here? ugh.
    taps = [
      "homebrew/core"
      "homebrew/bundle"
      "homebrew/cask"
      # "homebrew/cask-fonts"
      "homebrew/services"
      #"koekeishiya/formulae"
      "homebrew/cask-drivers" # for flipper zero
      # "fujiapple852/trippy"
    ];

    casks = [
      {
        name = "adobe-creative-cloud";
        greedy = true;
      }
      {
        name = "amethyst"; # for window tiling -- I miss chunkwm but it's successor, yabai, was unstable for me and required security compromises.
        greedy = true;
      }
      "audio-hijack" # used to use this for making my audio cleaner, but removed when I got a fancy audio setup. bringing back now (2024-07-11) to experiment with recording of sources
      # {
      # Replacing with open source ice bar 2024-11-29
      #   name = "bartender"; # organize status bar
      #   greedy = true;
      # }
      {
        name = "bettertouchtool";
        greedy = true;
      }
      "blockblock"
      {
        name = "brave-browser"; # TODO: move to home-manager when it builds
        greedy = true;
      }
      {
        name = "chatgpt";
        greedy = true;
      }
      "canon-eos-utility"
      #"canon-eos-webcam-utility"
      "choosy" # multi-browser url launch selector; see also https://github.com/johnste/finicky
      {
        name = "dash"; # offline developer docs
        greedy = true;
      }
      {
        name = "default-folder-x";
        greedy = true;
      }
      {
        name = "descript";
        greedy = true;
      }
      {
        name = "discord";
        greedy = true;
      }
      #"docker" # removed in favor of colima + docker cli
      {
        name = "dropbox";
        greedy = true;
      }
      {
        name = "elgato-stream-deck";
        greedy = true;
      }
      {
        name = "firefox"; # TODO: firefox build is broken on ARM; check to see if fixed
        greedy = true;
      }
      # {
      #   name = "focusrite-control-2";
      #   greedy = true;
      # }
      "freetube" # TODO: this is in nixpkgs now for darwin -- try there and see if we get arm

      {
        name = "fork";
        greedy = true;
      }
      "gitkraken-cli"
      {
        name = "google-drive";
        greedy = true;
      }
      {
        name = "gotomeeting";
        greedy = true;
      }
      {
        name = "gpg-suite";
        greedy = true;
      }
      "httpie"
      {
        name = "imageoptim";
        greedy = true;
      }
      "insta360-studio"
      {
        name = "istat-menus";
        greedy = true;
      }
      "jordanbaird-ice" # icebar alternative to bartender https://github.com/jordanbaird/Ice
      "keycastr"
      #"kitty" # would prefer to let nix install this as I have for over a year but post 15.1, nix version doesn't launch right
      {
        name = "kopiaui"; # ui for kopia dedupe backup
        greedy = true;
      }
      "knockknock"
      "league-of-legends"
      {
        name = "little-snitch";
        greedy = true;
      }
      #"lm-studio"
      "lockrattler"
      #"loopback" -- haven't been using this of late
      {
        name = "macwhisper";
        greedy = true;
      }
      {
        name = "marked";
        greedy = true;
      }
      #"microsoft-office" -- moved this to apple app store
      "stolendata-mpv" # 2024-12-11 switching to brew but keeping hm config; gui not launching
      "metasploit" # TODO 2024-07-31 nix version not running on mac
      "noun-project"
      {
        name = "obs"; # TODO: move to nix version obs-studio when not broken
        greedy = true;
      }
      {
        name = "orion"; # just trying out the Orion browser
        greedy = true;
      }
      {
        name = "parallels";
        greedy = true;
      }
      #"pomatez" # pomodoro timer, but installs itself as startup item and doesn't
      # give an option to disable that and doesn't ask you first. can
      # kill that in other ways, but that's a real negative sign to me
      {
        name = "proton-drive";
        greedy = true;
      }
      {
        name = "proton-mail"; # currently in beta, but snappier than web version
        greedy = true;
      }
      {
        name = "proton-mail-bridge"; # TODO: nix version now installs and works -- move over
        greedy = true;
      }
      "qflipper"
      "qutebrowser" # TODO: move over when it builds on arm64 darwin
      # Update: qutebrowser built today, 2023-09-07! but errors on launch :(
      {
        name = "qlmarkdown";
        greedy = true;
      }
      "qlstephen"
      #"qlprettypatch" # not updated in 9 years
      "qlvideo"
      #"quicklookase" # not updated in 6 years
      #"ripcord" # native (non-electron) desktop client for Slack + Discord -- try again in 2023
      "reikey"
      {
        name = "raycast";
        greedy = true;
      }
      {
        name = "rode-central";
        greedy = true;
      }
      {
        name = "screenflow";
        greedy = true;
      }
      # Following three things are for sketchybar
      "font-sf-pro"
      "font-sf-mono-for-powerline"
      "sf-symbols"
      {
        name = "signal"; # TODO: move to home-manager (signal-desktop) when not broken
        greedy = true;
      }
      "silentknight"
      "silnite"
      {
        name = "skype";
        greedy = true;
      }
      "subler" # used to edit metadata on videos
      "swiftdefaultappsprefpane"
      "sync"
      # {
      #   name = "syncthing"; # TODO: move to home-manager
      #   greedy = true;
      # }
      {
        name = "tor-browser"; # TODO: move to home-manager (tor-browser-bundle-bin) when it builds
        greedy = true;
      }
      {
        name = "transmission";
        greedy = true;
      }
      {
        name = "transmit"; # for syncing folders with dropbox on-demand instead of using their broken software
        greedy = true;
      }
      # why broken, you ask? well, they're using deprecated APIs for one thing
      # their sync service is constantly burning up CPU when nothing is touching their folder
      # and they install quicklook plugins that aren't optional and the adobe illustrator one
      # causes constant crashes whenever a folder or open/save dialog opens a folder with an
      # illustrator file in it. i reported it almost 3 years ago and there's a long thread of
      # others complaining about the same problem. i'd be done with dropbox entirely if i could.
      #"webpquicklook" # not updated in 5 years
      #"xbar"
      #"yattee" # private youtube
      # veracrypt requires macfuse which requires unsafe kernel extensions that
      # have to be enabled in recovery mode and... meh.
      #"veracrypt"
      #"macfuse" # needed by veracrypt
      "yubico-yubikey-manager" # TODO: move to home-manager (yubikey-manager works for ykman cli, but yubikey-manager-qt still broken)
      # Note also: yubico authenticator currently installed from mac app store. yubioath-flutter only works on linux
      {
        name = "zoom"; # TODO: move to home-manager (zoom-us)
        greedy = true;
      }
      {
        name = "zotero"; # TODO: move to home-manager?
        greedy = true;
      }
      # would be better to load these in a security shell, but nix versions don't build on mac
      "zap" # TODO: move to home-manager? (zap)
      # moving zed to home-manager 2025-05-12
      #"zed" # visual studio alternative in beta now; written in rust, uses gpu and multithreads to be smokin fast
      "burp-suite" # TODO: move to home-manager? (burpsuite)
      #"warp" # 2022-11-10 testing some crazy new rust-based terminal
      {
        name = "webex";
        greedy = true;
      }
      "wireshark-chmodbpf"

      # Keeping the next three together as they act in concert and are made by the same guy
      "kindavim" # ctrl-esc allows you to control an input area as if in vim normal mode
      "scrolla" # use vim commands to select scroll areas and scroll
      "wezterm"
      "wooshy" # use cmd-shift-space to bring up search to select interface elements in current app
    ];

    masApps = {
      "Amphetamine" = 937984704;
      "Apple Configurator 2" = 1037126344;
      #"Blurred" = 1497527363; # dim non-foreground windows -- removed when I realized this is Intel not ARM :-(
      "Boxy SVG" = 611658502; # nice code-oriented visual svg editor
      "Brother iPrint&Scan" = 1193539993;
      "Cardhop" = 1290358394; # contacts alternative
      "DaisyDisk" = 411643860;
      "Disk Decipher" = 516538625;
      "Disk Speed Test" = 425264550;
      #"Drafts" = 1435957248;
      "Fantastical" = 975937182; # calendar alternative
      "Forecast Bar" = 982710545;
      #"Ghostery – Privacy Ad Blocker" = 1436953057; # old version
      "Gifox 2" = 1461845568; # For short animated gif screen caps
      #"Ice Cubes" = 6444915884; # mastodon client -- it's good but i switched to ivory
      "iMovie" = 408981434;
      "iStumbler" = 546033581;
      "com.kagimacOS.Kagi-Search" = 1622835804; # Paid private search engine plugin for Safari
      "Kaleidoscope" = 587512244; # GUI 3-way merge
      "Keynote" = 409183694;
      "Keyshape" = 1223341056; # animated svg editor
      "Kindle" = 302584613;
      "MailTrackerBlocker" = 6450760473; # Mail extension for blocking tracker pixels
      "Microsoft Excel" = 462058435;
      "Microsoft Word" = 462054704;
      "Microsoft PowerPoint" = 462062816;
      "Monodraw" = 920404675; # ASCII drawings
      #"MsgFiler" = 6478043112; # Mail extension (sort of) for keyboard driven message filing
      #"NextDNS" = 1464122853;
      "NotePlan 3" = 1505432629;
      "PCalc" = 403504866;
      #"PeakHour" = 1560576252;
      "SQLPro Studio" = 985614903;
      "Save to Reader" = 1640236961; # readwise reader (my pocket replacement)
      "Scrivener" = 1310686187;
      "Slack" = 803453959;
      #"StopTheMadness" = 1376402589;
      "Strongbox" = 1270075435; # password manager
      # app store sandbox version doesn't allow some features like ssh
      #"Tailscale" = 1475387142; # P2P mesh VPN for my devices
      "Vimari" = 1480933944;
      "Vinegar" = 1591303229;
      #"WireGuard" = 1451685025; # VPN -- but tailscale does it all for me now
      "Xcode" = 497799835;
      "Yubico Authenticator" = 1497506650;
    };
    brews = [
      "ansiweather"
      "brightness"
      "ca-certificates"
      "chkrootkit" # TODO: moved here 2024-03-25 since nix version is broken
      "choose-gui"
      "ciphey"
      "ddcctl"
      "ical-buddy"
      "recon-ng" # TODO nix version doesn't work on mac at last try 2024-07-31
      #"whisper-cpp"
      #"whisperkit-cli"
      # would rather load these as part of a security shell, but...
      "hashcat" # the nix one only builds on linux
      "hydra" # the nix one only builds on linux
      "p0f" # the nix one only builds on linux
      "yt-dlp" # youtube downloader / 2024-11-19 moved back to nix now that curl-cffi (curl-impersonate) is supported
      # 2025-04-09 I'm getting errors saying curl-cffi is unavailable even though the nix recipe has it
      # so I'm adding it in both places for now
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
