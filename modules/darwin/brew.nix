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
      "mas"
      "ncspot"
      "wireshark-chmodbpf"
      "xbar"
      "zoom"
      "quicklook-csv"
      "quicklook-json"
      "quicklookase"
      "webpquicklook"
      "qlmarkdown"
      "qlprettypatch"
      "qlstephen"
      "qlvideo"
      "reikey"
      "revisionist"
      "silentknight"
      "systhist"
      "lockrattler"
      "chkrootkit"
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

############### to examine
#opus
#orc
#ossp-uuid
#p0f
#p11-kit
#p7zip
#packer
#pandoc
#pango
#pari
#pass
#pbc
#pcre
#pcre2
#pcsc-lite
#pdf2json
#pdfcrack
#pdftohtml
#peg-markdown
#perl
#pidof
#pillow
#pinentry
#pixman
#pkcs11-helper
#pkg-config
#pngcheck
#pngquant
#poppler
#popt
#portaudio
#postgresql
#procs
#proctools
#profanity
#protobuf
#protobuf-c
#proxmark3
#proxychains-ng
#psgrep
#pstree
#pth
#pwgen
#pwnat
#pwntools
#py3cairo
#pybind11
#pygobject3
#pyqt
#pyqt@5
#pyside
#python
#qemu
#qpdf
#qprint
#qrencode
#radare2
#rainbarf
#rav1e
#readline
#reaver
#recode
#recon-ng
#ripgrep
#ripgrep-all
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
#tickrs
#tidy-html5
#tig
#tika
#timewarrior
#tmux
#tokyo-cabinet
#topgrade
#torsocks
#tree
#tree-sitter
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
#youtube-dl
#yq
#yt-dlp
#ytop
#yubico-piv-tool
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
#alacritty
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
#gpg-suite
#graphql-playground
#gswitch
#hammerspoon
#iina
#isteg
#keepassxc
#kitty
#macdown
#marked
#osxfuse
#pacifist
#powershell
#transmission
#tunnelblick
#vulkan-sdk
#wkhtmltopdf
#zenmap

