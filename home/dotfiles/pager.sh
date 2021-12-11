#!/bin/sh

# I use fairly exhaustive extension lists in order to avoid the hit from checking the mimetype if possible

case "$1" in
  *.tar*|*.tgz) tar tf "$1" |less;;
  *.zip) unzip -l "$1" |less;;
  *.rar) unrar l "$1" |less;;
  *.7z) 7z l "$1" |less;;
  *.pdf) pdftotext "$1" - |less;;
  *.md) glow -p "$1";;
  *.arc|*.arj|*.taz|*.lha|*.lz4|*.lzh|*.lzma|*.tlz|*.txz|*.tzo|*.t7z|*.z|*.dz|*.gz|*.lrz|*.lz|*.lzo|*.xz|*.zst|*.tzst|*.bz2|*.bz|*.tbz|*.tbz2|*.tz|*.deb|*.rpm|*.jar|*.war|*.ear|*.sar|*.alz|*.ace|*.zoo|*.cpio|*.rz|*.cab|*.wim|*.swm|*.dwm|*.esd|*.jar) atool -l "$1" |less;;
  *.jpg|*.jpeg|*.gif|*.bmp|*.tif|*.tiff|*.png) exiftool "$1" |less;;
  *.mjpg|*.mjpeg|*.pbm|*.pgm|*.ppm|*.tga|*.xbm|*.xpm|*.svg|*.svgz|*.mng|*.pcx|*.mov|*.mpg|*.mpeg|*.m2v|*.mkv|*.webm|*.ogm|*.mp4|*.m4v|*.mp4v|*.vob|*.qt|*.nuv|*.wmv|*.asf|*.rm|*.rmvb|*.flc|*.avi|*.fli|*.flv|*.gl|*.dl|*.xcf|*.xwd|*.yuv|*.cgm|*.emf|*.ogv|*.ogx|*.aac|*.au|*.flac|*.m4a|*.mid|*.midi|*.mka|*.mp3|*.mpc|*.ogg|*.ra|*.wav|*.oga|*.opus|*.spx|*.xspf) mediainfo "$1" |less;;
  README.*|CONTRIBUTING|*.c|*.cc|*.cpp|*.css|*.go|*.h|*.hh|*.hpp|*.hs|*.html|*.java|*.js|*.json|*.lua|*.php|*.py|*.rb|*.scala|*.ts|*.jsx|*.tsx|*.sh|*.pl|*.rs|*.json|*.toml|*.conf|*.vim|*.bash|*.zsh|*.nix) bat "$1";;
  *)
    test -L "$1" && 1=$(readlink -f "$1")
    case $(file --mime-type "$1" -b) in
      text/*|*/json|*/xhtml)  bat "$1";;
      audio/*|video/*) mediainfo "$1"|less;;
      image/*) exiftool "$1"|less;;
      *) xxd "$1" |less;;
    esac
    ;;
esac

