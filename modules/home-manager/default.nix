{
  inputs,
  config,
  pkgs,
  username,
  lib,
  ...
}: let
  defaultPkgs = with pkgs.stable; [
    # filesystem
    fd
    ripgrep
    du-dust
    fzy
    curl
    duf # df alternative showing free disk space
    fswatch
    tree

    # compression
    atool
    unzip
    gzip
    xz
    zip

    # file viewers
    pkgs.pwnvim # moved my neovim config to its own repo for atomic management and install
    less
    page # like less, but uses nvim, which is handy for selecting out text and such
    file
    jq
    lynx
    sourceHighlight # for lf preview
    ffmpeg.bin
    ffmpegthumbnailer # for lf preview
    pandoc # for lf preview
    imagemagick # for lf preview
    highlight # code coloring in lf
    poppler_utils # for pdf2text in lf
    mediainfo # used by lf
    exiftool # used by lf
    rich-cli # used by lf (experimenting with mdcat replacement)
    exif
    glow # browse markdown dirs
    mdcat # colorize markdown
    html2text
    #pkgs.ctpv

    # network
    gping
    bandwhich # bandwidth monitor by process
    # not building on m1 right now
    #bmon # bandwidth monitor by interface
    caddy # local filesystem web server
    aria # cli downloader
    ncftp
    hostname
    xh # rust version of httpie / better curl

    # misc
    pkgs.ironhide # rust version of IronCore's ironhide
    pkgs.devenv # quick setup of dev envs for projects
    neofetch # display key software/version info in term
    #nodePackages.readability-cli # quick commandline website article read
    vimv # shell script to bulk rename
    pkgs.btop # currently like this better than bottom and htop
    #youtube-dl replaced by yt-dlp
    pkgs.yt-dlp
    vulnix # check for live nix apps that are listed in NVD
    pkgs.tickrs # track stocks
    #taskwarrior-tui
    aspell # spell checker
    kalker # cli calculator; alt. to bc and calc
    rink # calculator for unit conversions
    nix-tree # explore dependencies
    asciinema # terminal screencast
    ctags
    catimg # ascii rendering of any image in terminal x-pltfrm
    fortune
    ipcalc
    kondo # free disk space by cleaning project build dirs
    optipng
    pkgs.hackernews-tui
    procps
    pstree
    pkgs.gtm-okr
    pkgs.babble-cli # twitter tui
    pkgs.toot # mastodon tui
    yubikey-manager # cli for yubikey
    pkgs.zk # cli for indexing markdown files
    pastel # cli for color manipulation
    kopia # deduping backup
    pkgs.nps # quick nix packages search
    gnugrep
    pkgs.enola # sherlock-like tool
    #pkgs.qutebrowser
  ];
  # using unstable in my home profile for nix commands
  # nixEditorPkgs = with pkgs; [ nix statix ];

  networkPkgs = with pkgs.stable; [mtr iftop];
  guiPkgs = with pkgs;
    [
      element-desktop
      pkgs.pwneovide # wrapper makes a macos app for launching (and ensures it calls pwnvim)
      #dbeaver # database sql manager with er diagrams
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin
    [utm]; # utm is a qemu wrapper for mac only
in {
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
  home.packages = defaultPkgs ++ guiPkgs ++ networkPkgs;

  home.sessionVariables = {
    NIX_PATH = "nixpkgs=${inputs.nixpkgs-unstable}:stable=${inputs.nixpkgs-stable}\${NIX_PATH:+:}$NIX_PATH";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    #TERM = "xterm-256color";
    KEYTIMEOUT = 1;
    EDITOR = "nvim";
    VISUAL = "nvim";
    GIT_EDITOR = "nvim";
    LS_COLORS = "no=00:fi=00:di=01;34:ln=35;40:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:";
    LSCOLORS = "ExfxcxdxCxegedabagacad";
    FIGNORE = "*.o:~:Application Scripts:CVS:.git";
    TZ = "America/Denver";
    LESS = "--raw-control-chars -FXRadeqs -P--Less--?e?x(Next file: %x):(END).:?pB%pB%.";
    CLICOLOR = 1;
    CLICOLOR_FORCE = "yes";
    PAGER = "page -WO -q 90000";
    # Add colors to man pages
    MANPAGER = "less -R --use-color -Dd+r -Du+b +Gg -M -s";
    SYSTEMD_COLORS = "true";
    COLORTERM = "truecolor";
    FZF_CTRL_R_OPTS = "--sort --exact";
    BROWSER = "qutebrowser";
    TERMINAL = "alacritty";
    HOMEBREW_NO_AUTO_UPDATE = 1;
    #LIBVA_DRIVER_NAME="iHD";
    ZK_NOTEBOOK_DIR =
      if pkgs.stdenvNoCC.isDarwin
      then "/Users/${username}/Library/Containers/co.noteplan.NotePlan3/Data/Library/Application Support/co.noteplan.NotePlan3"
      else "/home/${username}/Notes";
  };

  home.file.".inputrc".text = ''
    set show-all-if-ambiguous on
    set completion-ignore-case on
    set mark-directories on
    set mark-symlinked-directories on

    # Do not autocomplete hidden files unless the pattern explicitly begins with a dot
    set match-hidden-files off

    # Show extra file information when completing, like `ls -F` does
    set visible-stats on

    # Be more intelligent when autocompleting by also looking at the text after
    # the cursor. For example, when the current line is "cd ~/src/mozil", and
    # the cursor is on the "z", pressing Tab will not autocomplete it to "cd
    # ~/src/mozillail", but to "cd ~/src/mozilla". (This is supported by the
    # Readline used by Bash 4.)
    set skip-completed-text on

    # Allow UTF-8 input and output, instead of showing stuff like $'\0123\0456'
    set input-meta on
    set output-meta on
    set convert-meta off

    # Use Alt/Meta + Delete to delete the preceding word
    "\e[3;3~": kill-word

    set keymap vi
    set editing-mode vi-insert
    "\e\C-h": backward-kill-word
    "\e\C-?": backward-kill-word
    "\eb": backward-word
    "\C-a": beginning-of-line
    "\C-l": clear-screen
    "\C-e": end-of-line
    "\ef": forward-word
    "\C-k": kill-line
    "\C-y": yank
    # Go up a dir with ctrl-n
    "\C-n":"cd ..\n"
    set editing-mode vi
  '';
  home.file.".direnvrc".text = ''
    source ~/.config/direnv/direnvrc
  '';
  home.file.".p10k.zsh".source = ./dotfiles/p10k.zsh;
  home.file.".wallpaper.jpg".source = ./wallpaper/castle2.jpg;
  home.file.".lockpaper.png".source = ./wallpaper/kali.png;

  # terminfo to allow rich handling of italics, 256 colors, etc.
  # these files were generated from the dotfiles dir which has a terminfo.src
  # downloaded from https://invisible-island.net/datafiles/current/terminfo.src.gz
  # the terminfo definitions were created with the command:
  # tic -xe alacritty,alacritty-direct,kitty,kitty-direct,tmux-256color -o terminfo terminfo.src
  # Also did this for xterm-kitty (from within kitty so TERMINFO is set)
  # tic -x -o ~/.terminfo $TERMINFO/kitty.terminfo
  # Then copied out the resulting ~/.terminfo/78/xterm-kitty file
  # I'm not sure if this is OS dependent. For now, only doing this on Darwin. Possibly I should generate
  # on each local system first in a derivation
  home.file.".terminfo/61/alacritty".source = ./dotfiles/terminfo/61/alacritty;
  home.file.".terminfo/61/alacritty-direct".source =
    ./dotfiles/terminfo/61/alacritty-direct;
  home.file.".terminfo/6b/kitty".source = ./dotfiles/terminfo/6b/kitty;
  home.file.".terminfo/6b/kitty-direct".source =
    ./dotfiles/terminfo/6b/kitty-direct;
  home.file.".terminfo/74/tmux-256color".source =
    ./dotfiles/terminfo/74/tmux-256color;
  home.file.".terminfo/78/xterm-kitty".source =
    ./dotfiles/terminfo/78/xterm-kitty;
  home.file.".terminfo/x/xterm-kitty".source =
    ./dotfiles/terminfo/78/xterm-kitty;

  # Config for hackernews-tui to make it darker
  home.file.".config/hn-tui.toml".text = ''
    [theme.palette]
    background = "#242424"
    foreground = "#f6f6ef"
    selection_background = "#4a4c4c"
    selection_foreground = "#d8dad6"
  '';
  home.file."Library/Preferences/espanso/match/base.yml".text = pkgs.lib.generators.toYAML {} {
    matches = [
      {
        trigger = "icphone";
        replace = "415.968.9607";
      }
      {
        trigger = ":checkbox:";
        replace = "⬜️";
      }
      {
        trigger = ":checked:";
        replace = "✅";
      }
      {
        trigger = ":checkmark:";
        replace = "✓";
      }
      {
        trigger = "acmlink";
        replace = "https://dl.acm.org/citation.cfm?id=3201602";
      }
      {
        trigger = "icaddr1";
        replace = "1750 30th Street #500";
      }
      {
        trigger = "icaddr2";
        replace = "Boulder, CO 80301-1029";
      }
      {
        trigger = "icoffice1";
        replace = "1919 14th Street, 7th Floor";
      }
      {
        trigger = "icoffice2";
        replace = "Boulder, CO 80302";
      }
      {
        trigger = "..p";
        replace = "..Patrick";
      }
      {
        trigger = "myskype";
        replace = "303.731.3155";
      }
      {
        trigger = "-icc";
        replace = "ironcorelabs.com";
      }
      {
        trigger = "--icl";
        replace = "IronCore Labs";
      }
      {
        trigger = ".zsg";
        replace = ".zmre@spamgourmet.com";
      }
      {
        trigger = "mycal";
        replace = "https://app.hubspot.com/meetings/patrick-walsh";
      }
      {
        trigger = "p@i";
        replace = "patrick.walsh@ironcorelabs.com";
      }
      {
        trigger = "p@w";
        replace = "pwalsh@well.com";
      }
      {
        trigger = "--sig";
        replace = ''
          --
          Patrick Walsh  ●  CEO
          patrick.walsh@ironcorelabs.com  ●  @zmre

          IronCore Labs
          Strategic privacy for modern SaaS.
          https://ironcorelabs.com  ●  @ironcorelabs  ●  415.968.9607
        '';
      }
      {
        # Dates
        trigger = "ddate";
        replace = "{{mydate}}";
        vars = [
          {
            name = "mydate";
            type = "date";
            params = {format = "%Y-%m-%d";};
          }
        ];
      }
      {
        # Shell commands example
        trigger = ":shell";
        replace = "{{output}}";
        vars = [
          {
            name = "output";
            type = "shell";
            params = {cmd = "echo Hello from your shell";};
          }
        ];
      }
    ];
  };

  programs.bat = {
    enable = true;
    #extraPackages = with pkgs.bat-extras; [ batman batgrep ];
    config = {
      theme = "Dracula"; # I like the TwoDark colors better, but want bold/italic in markdown docs
      #pager = "less -FR";
      pager = "page -WO -q 90000";
      italic-text = "always";
      style = "plain"; # no line numbers, git status, etc... more like cat with colors
    };
  };
  programs.nix-index.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.taskwarrior = {
    enable = false;
    colorTheme = "dark-256";
    dataLocation = "~/.task";
    config = {
      urgency.user.tag.networking.coefficient = -10.0;
      uda.reviewed.type = "date";
      uda.reviewed.label = "Reviewed";
      report._reviewed.description = "Tasksh review report.  Adjust the filter to your needs.";
      report._reviewed.columns = "uuid";
      report._reviewed.sort = "reviewed+,modified+";
      report._reviewed.filter = "( reviewed.none: or reviewed.before:now-6days ) and ( +PENDING or +WAITING )";
      search.case.sensitive = "no";
      # Shortcuts
      alias.dailystatus = "status:completed end.after:today all";
      alias.punt = "modify wait:1d";
      alias.someday = "mod +someday wait:someday";

      # task ready report default with custom columns
      default.command = "ready";
      report.ready.columns = "id,start.active,depends.indicator,project,due.relative,description.desc";
      report.ready.labels = ",,Depends, Project, Due, Description";
      #if none of the tasks in a report have a particular column, it will not show in the report

      report.minimal.columns = "id,project,description.truncated";
      report.minimal.labels = " , Project, Description";
      report.minimal.sort = "project+/,urgency-";

      # Indicate the active task in reports
      active.indicator = ">";
      # Show the tracking of time
      journal.time = "on";
    };
  };

  # Prose linting
  home.file."${config.xdg.configHome}/proselint/config.json".text = ''
    {
      "checks": {
        "typography.symbols.curly_quotes": false,
        "typography.symbols.ellipsis": false
      }
    }
  '';
  home.file.".styles".source = ./dotfiles/vale-styles;
  home.file.".vale.ini".text = ''
    StylesPath = .styles

    MinAlertLevel = suggestion

    Packages = proselint, alex, Readability

    [*]
    BasedOnStyles = Vale, proselint
    IgnoredScopes = code, tt
    SkippedScopes = script, style, pre, figure
    Google.FirstPerson = NO
    Google.We = NO
    Google.Acronyms = NO
    Google.Units = NO
    Google.Spacing = NO
    Google.Exclamation = NO
    Google.Headings = NO
    Google.Parens = NO
    Google.DateFormat = NO
    Google.Ellipses = NO
    proselint.Typography = NO
    Vale.Spelling = NO
  '';

  # I really don't use VSCode. I try it now and then to see what I think.
  # My setup uses Neovim in the background whenever you go to Normal mode.
  # But it is a little bit buggy and though it's slightly prettier, not
  # currently worth it. I'm still keeping it in because of pair programming
  # stuff for that rare occasion.
  programs.vscode = {
    enable = true;
    mutableExtensionsDir =
      true; # to allow vscode to install extensions not available via nix
    # package = pkgs.vscode-fhs; # or pkgs.vscodium or pkgs.vscode-with-extensions
    extensions = with pkgs.vscode-extensions; [
      scala-lang.scala
      svelte.svelte-vscode
      redhat.vscode-yaml
      jnoortheen.nix-ide
      vspacecode.whichkey # ?
      bungcip.better-toml
      esbenp.prettier-vscode
      timonwong.shellcheck
      matklad.rust-analyzer
      graphql.vscode-graphql
      dbaeumer.vscode-eslint
      codezombiech.gitignore
      bierner.markdown-emoji
      bradlc.vscode-tailwindcss
      naumovs.color-highlight
      mikestead.dotenv
      mskelton.one-dark-theme
      prisma.prisma
      asvetliakov.vscode-neovim
      brettm12345.nixfmt-vscode
      davidanson.vscode-markdownlint
      pkief.material-icon-theme
      dracula-theme.theme-dracula
      eamodio.gitlens # for git blame
      marp-team.marp-vscode # for markdown slides
      pkgs.kubernetes-yaml-formatter # format k8s; from overlays and flake input
      # live share not currently working via nix
      #ms-vsliveshare.vsliveshare # live share coding with others
      # wishlist
      # ardenivanov.svelte-intellisense
      # cschleiden.vscode-github-actions
      # csstools.postcss
      # stylelint.vscode-stylelint
      # vunguyentuan.vscode-css-variables
      # ZixuanChen.vitest-explorer
      # bettercomments ?
    ];
    # starting point for bindings: https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/keybindings.json
    keybindings = [
      {
        "key" = "ctrl+e";
        "command" = "workbench.view.explorer";
      }
      {
        "key" = "shift+ctrl+e";
        "command" = "-workbench.view.explorer";
      }
    ];
    userSettings = {
      # Much of the following adapted from https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/settings.json
      "editor.tabSize" = 2;
      "editor.fontLigatures" = true;
      "editor.guides.indentation" = false;
      "editor.insertSpaces" = true;
      "editor.fontFamily" = "'Hasklug Nerd Font', 'JetBrainsMono Nerd Font', 'FiraCode Nerd Font','SF Mono', Menlo, Monaco, 'Courier New', monospace";
      "editor.fontSize" = 12;
      "editor.formatOnSave" = true;
      "editor.suggestSelection" = "first";
      "editor.scrollbar.horizontal" = "hidden";
      "editor.scrollbar.vertical" = "hidden";
      "editor.scrollBeyondLastLine" = false;
      "editor.cursorBlinking" = "solid";
      "editor.minimap.enabled" = false;
      "[nix]"."editor.tabSize" = 2;
      "[svelte]"."editor.defaultFormatter" = "svelte.svelte-vscode";
      "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "extensions.ignoreRecommendations" = false;
      "files.insertFinalNewline" = true;
      "[scala]"."editor.tabSize" = 2;
      "[json]"."editor.tabSize" = 2;
      "vim.highlightedyank.enable" = true;
      "files.trimTrailingWhitespace" = true;
      "gitlens.codeLens.enabled" = false;
      "gitlens.currentLine.enabled" = false;
      "gitlens.hovers.currentLine.over" = "line";
      "vsintellicode.modify.editor.suggestSelection" = "automaticallyOverrodeDefaultValue";
      "java.semanticHighlighting.enabled" = true;
      "workbench.editor.showTabs" = true;
      "workbench.list.automaticKeyboardNavigation" = false;
      "workbench.activityBar.visible" = false;
      #"workbench.colorTheme" = "Dracula";
      "workbench.colorTheme" = "One Dark";
      "workbench.iconTheme" = "material-icon-theme";
      "editor.accessibilitySupport" = "off";
      "oneDark.bold" = true;
      "window.zoomLevel" = 1;
      "window.menuBarVisibility" = "toggle";
      #"terminal.integrated.shell.linux" = "${pkgs.zsh}/bin/zsh";

      "svelte.enable-ts-plugin" = true;
      "javascript.inlayHints.functionLikeReturnTypes.enabled" = true;
      "javascript.referencesCodeLens.enabled" = true;
      "javascript.suggest.completeFunctionCalls" = true;

      "vscode-neovim.neovimExecutablePaths.darwin" = "${pkgs.neovim}/bin/nvim";
      "vscode-neovim.neovimExecutablePaths.linux" = "${pkgs.neovim}/bin/nvim";
      /*
      "vscode-neovim.neovimInitVimPaths.darwin" = "$HOME/.config/nvim/init.vim";
      "vscode-neovim.neovimInitVimPaths.linux" = "$HOME/.config/nvim/init.vim";
      */
      "editor.tokenColorCustomizations" = {
        "textMateRules" = [
          {
            "name" = "One Dark bold";
            "scope" = [
              "entity.name.function"
              "entity.name.type.class"
              "entity.name.type.module"
              "entity.name.type.namespace"
              "keyword.other.important"
            ];
            "settings" = {"fontStyle" = "bold";};
          }
          {
            "name" = "One Dark italic";
            "scope" = [
              "comment"
              "entity.other.attribute-name"
              "keyword"
              "markup.underline.link"
              "storage.modifier"
              "storage.type"
              "string.url"
              "variable.language.super"
              "variable.language.this"
            ];
            "settings" = {"fontStyle" = "italic";};
          }
          {
            "name" = "One Dark italic reset";
            "scope" = [
              "keyword.operator"
              "keyword.other.type"
              "storage.modifier.import"
              "storage.modifier.package"
              "storage.type.built-in"
              "storage.type.function.arrow"
              "storage.type.generic"
              "storage.type.java"
              "storage.type.primitive"
            ];
            "settings" = {"fontStyle" = "";};
          }
          {
            "name" = "One Dark bold italic";
            "scope" = ["keyword.other.important"];
            "settings" = {"fontStyle" = "bold italic";};
          }
        ];
      };
    };
  };
  # VSCode whines like a ... I don't know, but a lot when the config file is read-only
  # I want nix to govern the configs, but to let vscode edit it (ephemerally) if I change
  # the zoom or whatever. This hack just copies the symlink to a normal file
  home.activation.vscodeWritableConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    code_dir="$(echo ~/Library)/Application Support/Code/User"
    settings="$code_dir/settings.json"
    settings_nix="$code_dir/settings.nix.json"
    settings_bak="$settings.bak"

    echo "activating $settings"

    $DRY_RUN_CMD mv "$settings" "$settings_nix"
    $DRY_RUN_CMD cp -H "$settings_nix" "$settings"
    $DRY_RUN_CMD chmod u+w "$settings"
    $DRY_RUN_CMD rm "$settings_bak"
  '';

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
    defaultCommand = "fd --type f --hidden --exclude .git";
    fileWidgetCommand = "fd --type f"; # for when ctrl-t is pressed
  };
  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    includes = ["*.conf"];
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
  programs.gh = {
    enable = true;
    # stable is currently failing as of 2022-02-17
    # error: Could not find a version that satisfies the requirement tomlkit<0.8,>=0.7 (from remarshal)
    package = pkgs.gh;
    settings = {git_protocol = "ssh";};
  };
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [thumbnail sponsorblock];
    config = {
      # disable on-screen controller -- else I get a message saying I have to add this
      osc = false;
      # Use a large seekable RAM cache even for local input.
      cache = true;
      save-position-on-quit = false;
      #x11-bypass-compositor = true;
      #no-border = true;
      msg-color = true;
      pause = true;
      # This will force use of h264 instead vp8/9 so hardware acceleration works
      ytdl-format = "bv*[ext=mp4]+ba/b";
      #ytdl-format = "bestvideo+bestaudio";
      # have mpv use yt-dlp instead of youtube-dl
      script-opts-append = "ytdl_hook-ytdl_path=${pkgs.yt-dlp}/bin/yt-dlp";
      autofit-larger = "100%x95%"; # resize window in case it's larger than W%xH% of the screen
      input-media-keys = "yes"; # enable/disable OSX media keys
      hls-bitrate = "max"; # use max quality for HLS streams

      user-agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:57.0) Gecko/20100101 Firefox/58.0";
    };
    defaultProfiles = ["gpu-hq"];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    # let's the terminal track current working dir but only builds on linux
    enableVteIntegration =
      if pkgs.stdenvNoCC.isDarwin
      then false
      else true;

    history = {
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      save = 10000; # save 10,000 lines of history
    };
    defaultKeymap = "viins";
    # things to add to .zshenv
    envExtra = ''
      # don't use global env as it will slow us down
      skip_global_compinit=1
    '';
    #initExtraBeforeCompInit = "";
    completionInit = ''
      # only update compinit once each day
      # better solution would be to pre-build zcompdump with compinit call then link it in
      # and never recalculate
      autoload -Uz compinit
      for dump in ~/.zcompdump(N.mh+24); do
        compinit
      done
      compinit -C
    '';
    initExtraFirst = ''
      #zmodload zsh/zprof
      source ${./dotfiles/p10k.zsh}
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      # Prompt stuff
      #if [[ -r "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh" ]]; then
        #source "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh"
      #fi
    '';
    initExtra = ''
      set -o vi
      bindkey -v

      # Setup preferred key bindings that emulate the parts of
      # emacs-style input manipulation that I'm familiar with
      bindkey '^P' up-history
      bindkey '^N' down-history
      bindkey '^?' backward-delete-char
      bindkey '^h' backward-delete-char
      bindkey '^w' backward-kill-word
      bindkey '\e^h' backward-kill-word
      bindkey '\e^?' backward-kill-word
      bindkey '^r' history-incremental-search-backward
      bindkey '^a' beginning-of-line
      bindkey '^e' end-of-line
      bindkey '\eb' backward-word
      bindkey '\ef' forward-word
      bindkey '^k' kill-line
      bindkey '^u' backward-kill-line

      # I prefer for up/down and j/k to do partial searches if there is
      # already text in play, rather than just normal through history
      bindkey '^[[A' up-line-or-search
      bindkey '^[[B' down-line-or-search
      bindkey -M vicmd 'k' up-line-or-search
      bindkey -M vicmd 'j' down-line-or-search
      bindkey '^r' history-incremental-search-backward
      bindkey '^s' history-incremental-search-forward

      # You might not like what I'm doing here, but '/' works like ctrl-r
      # and matches as you type. I've added pattern matches here though.

      bindkey -M vicmd '/' history-incremental-pattern-search-backward # default is vi-history-search-backward
      bindkey -M vicmd '?' vi-history-search-backward # default is vi-history-search-forward

      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd 'v' edit-command-line

      zstyle ':completion:*' completer _extensions _complete _approximate
      zstyle ':completion:*' menu select
      zstyle ':completion:*:manuals'    separate-sections true
      zstyle ':completion:*:manuals.*'  insert-sections   true
      zstyle ':completion:*:man:*'      menu yes select
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.zsh/cache
      zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
      zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
      zstyle ':completion:*:*:kill:*' menu yes select
      zstyle ':completion:*:kill:*'   force-list always
      # TODO: need to look this up as below is broken
      zstyle -e ':completion:*:default' list-colors 'reply=("$''${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:''${(s.:.)LS_COLORS}")'

      # taskwarrior
      zstyle ':completion:*:*:task:*' verbose yes
      zstyle ':completion:*:*:task:*:descriptions' format '%U%B%d%b%u'
      zstyle ':completion:*:*:task:*' group-name '\'

      zmodload -a colors
      # TODO: need to look this up as below is broken
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS} # complete with same colors as ls
      zstyle ':completion:*:*:*:*:hosts' list-colors '=*=1;36' # bold cyan
      zstyle ':completion:*:*:*:*:users' list-colors '=*=36;40' # dark cyan on black

      setopt list_ambiguous

      zmodload -a autocomplete
      zmodload -a complist

      # Customize fzf plugin to use fd
      # Should default to ignore anything in ~/.gitignore
      #export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
      # Use fd (https://github.com/sharkdp/fd) instead of the default find
      # command for listing path candidates.
      # - The first argument to the function ($1) is the base path to start traversal
      # - See the source code (completion.{bash,zsh}) for the details.
      #_fzf_compgen_path() {
        #\fd --hidden --follow . "$1"
      #}

      # Use fd to generate the list for directory completion
      #_fzf_compgen_dir() {
        #\fd --type d --hidden --follow . "$1"
      #}

      # Per https://github.com/junegunn/fzf/wiki/Configuring-fuzzy-completion
      # Since fzf init comes before this, and we setopt vi, we need to reassign:
      bindkey '^I' fzf-completion

      # Needed for lf to be pretty
      . ~/.config/lf/lficons.sh

      # Setup zoxide
      eval "$(zoxide init zsh)"

      #source ${./dotfiles/p10k.zsh}

      #zprof
    '';
    sessionVariables = {};
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];
    # oh-my-zsh.enable = true;
    # oh-my-zsh.plugins = [
    #   "sudo"
    #   "gitfast"
    #   "vim-interaction"
    #   "docker"
    #   "taskwarrior"
    #   "tmux"
    #   "fzf"
    #   "cargo"
    #   "brew"
    #   "ripgrep"
    #   "vi-mode"
    #   "zoxide"
    # ];
    shellAliases =
      {
        ls = "ls --color=auto -F";
        l = "exa --icons --git-ignore --git -F --extended";
        ll = "exa --icons --git-ignore --git -F --extended -l";
        lt = "exa --icons --git-ignore --git -F --extended -T";
        llt = "exa --icons --git-ignore --git -F --extended -l -T";
        fd = "\\fd -H -t d"; # default search directories
        f = "\\fd -H"; # default search this dir for files ignoring .gitignore etc
        lf = "~/.config/lf/lfimg";
        nixosedit = "nvim $(realpath /etc/nixos/configuration.nix) ; sudo nixos-rebuild switch --flake ~/.config/nixpkgs/.#";
        nixedit = "nvim ~/.config/nixpkgs/home.nix ; sudo nixos-rebuild switch --flake ~/.config/nixpkgs/.#";
        qp = ''
          qutebrowser --temp-basedir --set content.private_browsing true --set colors.tabs.bar.bg "#552222" --config-py "$HOME/.config/qutebrowser/config.py" --qt-arg name "qp,qp"'';
        calc = "kalker";
        df = "duf";
        # search for a note and with ctrl-n, create it if not found
        # add subdir as needed like "n meetings" or "n wiki"
        n = "zk edit --interactive";
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        # Figure out the uniform type identifiers and uri schemes of a file (must specify the file)
        # for use in SwiftDefaultApps
        checktype = "mdls -name kMDItemContentType -name kMDItemContentTypeTree -name kMDItemKind";
        dwupdate = "pushd ~/.config/nixpkgs ; nix flake update ; /opt/homebrew/bin/brew update; popd ; dwswitch ; /opt/homebrew/bin/brew upgrade ; /opt/homebrew/bin/brew upgrade --cask --greedy; popd";
        dwswitch = "pushd ~; cachix watch-exec zmre darwin-rebuild -- switch --flake ~/.config/nixpkgs/.#$(hostname -s) ; popd";
        dwswitchx = "pushd ~; darwin-rebuild switch --flake ~/.config/nixpkgs/.#$(hostname -s) ; popd";
        dwclean = "pushd ~; sudo nix-env --delete-generations +7 --profile /nix/var/nix/profiles/system; sudo nix-collect-garbage --delete-older-than 30d ; nix store optimise ; popd";
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
        hmswitch = ''
          nix-shell -p home-manager --run "home-manager switch --flake ~/.config/nixpkgs/.#$(hostname -s)"'';
        noupdate = "pushd ~/.config/nixpkgs; nix flake update; popd; noswitch";
        noswitch = "pushd ~; sudo cachix watch-exec zmre nixos-rebuild -- switch --flake ~/.config/nixpkgs/.# ; popd";
      };
  };

  programs.exa.enable = true;
  programs.pistol = {
    # I've gone back to my pv.sh script for now
    enable = false;
    associations = [
      {
        mime = "text/*";
        command = "bat --paging=never --color=always %pistol-filename%";
      }
      {
        mime = "image/*";
        command = "kitty +kitten icat --silent --transfer-mode=stream --stdin=no %pistol-filename%";
      }
    ];
  };
  # my preferred file explorer; mnemonic: list files
  programs.lf = {
    enable = true;
    settings = {
      icons = true;
      incsearch = true;
      ifs = "\n";
      findlen = 2;
      scrolloff = 3;
      drawbox = true;
      promptfmt = "\\033[1;38;5;51m[\\033[38;5;39m%u\\033[38;5;51m@\\033[38;5;39m%h\\033[38;5;51m] \\033[0;38;5;49m%w/\\033[38;5;48m%f\\033[0m";
    };
    extraConfig = ''
      set incfilter
      set mouse
      set truncatechar ⋯
      set cleaner ${./dotfiles/lf/cls.sh}
    '';
    previewer = {
      keybinding = "i";
      source = ./dotfiles/lf/pv.sh;
      # source = "${pkgs.pistol}/bin/pistol";
      # source = ./dotfiles/lf/lf_kitty_preview;
    };
    # NOTE: some weird syntax below. let me explain. if you have a ${} inside a quote, you escape this way:
    # "\${escaped}"
    # ''blah''${escaped}blah''
    # So you use double apostrophe to escape the ${. Weird but effective. See
    # https://nixos.org/guides/nix-pills/basics-of-language.html#idm140737320582880
    commands = {
      "fd_dir" = ''
        ''${{
                res="$(\fd -H -t d | fzy -l 20 2>/dev/tty | sed 's|\\|\\\\|g;s/"/\\"/g')"
                [ ! -z "$res" ] && lf -remote "send $id cd \"$res\""
              }}'';

      "f_file" = ''
        ''${{
                res="$(\fd -H | fzy -l 20 2>/dev/tty | sed 's|\\|\\\\|g;s/"/\\"/g')"
                [ ! -z "$res" ] && lf -remote "send $id select \"$res\""
              }}'';
      z = ''
        ''${{
                res="$(zoxide query --exclude "$PWD" -- "$1")"
                [ ! -z "$res" ] && lf -remote "send $id cd \"$res\""
              }}'';
      # Purpose of this is to allow for opening multiple selected files. Default only works on one.
      # Default will use data from mimetype associations.
      # Note: this gets overridden when in selection-path (file dialog) mode
      # Fancy command isn't working; let the default go to work
      #open = ''
      #&{{ for f in $fx; do xdg-open "$f" 2>&1 > /dev/null || open "$f" 2>&1 > /dev/null" ; done }}'';

      # for use as file chooser
      printfx = "\${{echo $fx}}";

      "vi-rename" = ''
        ''${{
                vimv $fx
                lf -remote "send $id echo '$(cat /tmp/.vimv-latest)'"
                lf -remote 'send load'
                lf -remote 'send clear'
              }}'';
      "fzf_search" = ''
        ''${{
            res="$( \
                RG_PREFIX="${pkgs.ripgrep}/bin/rg --column --line-number --no-heading --color=always --smart-case "
                FZF_DEFAULT_COMMAND="$RG_PREFIX \'\' " fzf --bind "change:reload:$RG_PREFIX {q} || true" --ansi --layout=reverse --header 'Search in files' | cut -d':' -f1
            )"
            [ ! -z "$res" ] && lf -remote "send $id select \"$res\""
        }}'';
    };
    keybindings = {
      "." = "set hidden!";
      #i = "!~/.config/lf/pager.sh $f"; # mnemonic: info
      # use the system open command
      o = "open";
      I = "!/usr/bin/qlmanage -p $f";
      "<c-z>" = "$ kill -STOP $PPID";
      "gr" = "fzf_search"; # ripgrep search
      "gd" = "fd_dir"; # mnemonic: go find dir
      "gf" = "f_file"; # mnemonic: go find file
      "gz" = "push :z<space>"; # mnemonic: go zoxide
      "R" = "vi-rename";
      "<enter>" = ":printfx; quit";
    };
  };
  home.file.".config/lf/lfimg".source = ./dotfiles/lf/lfimg;
  home.file.".config/lf/lf_kitty_preview".source =
    ./dotfiles/lf/lf_kitty_preview;
  home.file.".config/lf/pv.sh".source = ./dotfiles/lf/pv.sh;
  home.file.".config/lf/cls.sh".source = ./dotfiles/lf/cls.sh;
  #home.file.".config/lf/previewer.sh".source = ./dotfiles/lf/previewer.sh;
  home.file.".config/lf/pager.sh".source = ./dotfiles/lf/pager.sh;
  home.file.".config/lf/lficons.sh".source = ./dotfiles/lf/lficons.sh;
  programs.git = {
    enable = true;
    userName = "Patrick Walsh";
    userEmail = "patrick.walsh@ironcorelabs.com";
    aliases = {
      gone = ''
        ! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == "[gone]" {print $1}' | xargs -r git branch -D'';
      tatus = "status";
      co = "checkout";
      br = "branch";
      st = "status -sb";
      wtf = "!git-wtf";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --topo-order --date=relative";
      gl = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --topo-order --date=relative";
      lp = "log -p";
      lr = "reflog";
      ls = "ls-files";
      dall = "diff";
      d = "diff --relative";
      dv = "difftool";
      df = "diff --relative --name-only";
      dvf = "difftool --relative --name-only";
      dfall = "diff --name-only";
      ds = "diff --relative --name-status";
      dvs = "difftool --relative --name-status";
      dsall = "diff --name-status";
      dvsall = "difftool --name-status";
      dr = "diff-index --cached --name-only --relative HEAD";
      di = "diff-index --cached --patch --relative HEAD";
      dfi = "diff-index --cached --name-only --relative HEAD";
      subpull = "submodule foreach git pull";
      subco = "submodule foreach git checkout master";
    };
    extraConfig =
      {
        github.user = "zmre";
        color.ui = true;
        pull.rebase = true;
        merge.conflictstyle = "diff3";
        init.defaultBranch = "main";
        http.sslVerify = true;
        commit.verbose = true;
        credential.helper =
          if pkgs.stdenvNoCC.isDarwin
          then "osxkeychain"
          else "cache --timeout=10000000";
        diff.algorithm = "patience";
        protocol.version = "2";
        core.commitGraph = true;
        gc.writeCommitGraph = true;
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        # these should speed up vim nvim-tree and other things that watch git repos but
        # only works on mac. see https://github.com/nvim-tree/nvim-tree.lua/wiki/Troubleshooting#git-fsmonitor-daemon
        core.fsmonitor = true;
        core.untrackedcache = true;
      };
    # Really nice looking diffs
    delta = {
      enable = false;
      options = {
        syntax-theme = "Monokai Extended";
        line-numbers = true;
        navigate = true;
        side-by-side = true;
      };
    };
    # intelligent diffs that are syntax parse tree aware per language
    difftastic = {
      enable = true;
      background = "dark";
    };
    #ignores = [ ".cargo" ];
    ignores = import ./dotfiles/gitignore.nix;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shell = "${pkgs.zsh}/bin/zsh";
    historyLimit = 10000;
    escapeTime = 0;
    extraConfig = builtins.readFile ./dotfiles/tmux.conf;
    sensibleOnTop = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.open
      {
        plugin = tmuxPlugins.fzf-tmux-url;
        # default key bind is ctrl-b, u
        extraConfig = ''
          set -g @fzf-url-history-limit '2000'
          set -g @open-S 'https://www.duckduckgo.com/'
        '';
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-processes ': all:'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
    ];
  };

  programs.newsboat = {
    enable = true;
    autoReload = true;
    browser =
      if pkgs.stdenvNoCC.isDarwin
      then "open"
      else "${pkgs.xdg-utils}/bin/xdg-open";
    maxItems = 100;
    extraConfig = ''
      show-read-feeds  no
      bind-key j next-unread
      bind-key k prev-unread
      highlight article "^(Feed|Title|Author|Link|Date):.*$" yellow default bold
      highlight article "https?://[^ ]+" blue default underline
    '';
    urls = [
      {
        tags = ["security"];
        title = "Cyberscoop";
        url = "https://www.cyberscoop.com/feed/";
      }
      {
        tags = ["security"];
        title = "Krebs on Security";
        url = "https://krebsonsecurity.com/feed/";
      }
      {
        tags = ["security"];
        title = "DefenseOne";
        url = "http://www.defenseone.com/rss/technology/ ";
      }
      {
        tags = ["news"];
        title = "NPR";
        url = "http://www.npr.org/rss/rss.php?id=1001";
      }
      {
        tags = ["news"];
        title = "Reuters Domestic";
        url = "http://feeds.reuters.com/Reuters/domesticNews";
      }
      {
        tags = ["startup"];
        title = "TechCrunch";
        url = "https://techcrunch.com/feed/";
      }
      {
        tags = ["tech"];
        title = "Reuters Tech";
        url = "http://feeds.reuters.com/reuters/technologyNews?format=xml";
      }
      {
        tags = ["tech"];
        title = "EFF";
        url = "http://www.eff.org/rss/updates.xml";
      }
    ];
  };

  # 2022-11-06 going to try kitty for a bit
  programs.kitty = {
    enable = true;
    keybindings = {
      "super+equal" = "increase_font_size";
      "super+minus" = "decrease_font_size";
      "super+0" = "restore_font_size";
      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";
      # cmd-[ and cmd-] switch tmux windows
      # \x02 is ctrl-b so sequence below is ctrl-b, h
      "cmd+[" = "send_text all \\x02h";
      "cmd+]" = "send_text all \\x02l";
      "ctrl+shift+h" = "neighboring_window left";
      "ctrl+shift+j" = "neighboring_window down";
      "ctrl+shift+k" = "neighboring_window up";
      "ctrl+shift+l" = "neighboring_window right";
    };
    font = {
      name = "Hasklug Nerd Font Mono Medium";
      #name = "Hasklug Nerd Font Medium"; # regular is too thin
      #name = "Inconsolata Nerd Font"; # no italic
      #name = "SpaceMono Nerd Font Mono";
      #name = "VictorMono Nerd Font";
      #name = "FiraCode Nerd Font"; # missing italic
      size =
        if pkgs.stdenvNoCC.isDarwin
        then 17
        else 12;
    };
    darwinLaunchOptions = ["--single-instance"];
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      macos_option_as_alt = "both";
      macos_quit_when_last_window_closed = true;
      adjust_line_height = "105%";
      disable_ligatures = "cursor"; # disable ligatures when cursor is on them
      shell_integration = "enabled";

      # Fonts
      bold_font = "Hasklug Nerd Font Mono Bold"; # "auto";
      italic_font = "Hasklug Nerd Font Mono Italic";
      bold_italic_font = "Hasklug Nerd Font Mono Bold Italic";

      # Window layout
      #hide_window_decorations = "titlebar-only";
      window_padding_width = "5";
      macos_show_window_title_in = "window";

      # Tab bar
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_title_template = "{index}: {title}";

      # Colors
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
      active_tab_foreground = "#ffffff";
      active_tab_background = "#2233ff";
      tab_activity_symbol = " ";

      # Misc
      # I forget why I was allowing remote control now. I had a reason, but I don't think
      # I'm using it now. We'll see what breaks. It seems to be slowing down new windows. 2023-01-21
      #allow_remote_control = "socket-only";
      #listen_on = "unix:/tmp/kitty-sock";
      visual_bell_duration = "0.1";
      background_opacity = "0.95";
      startup_session = "~/.config/kitty/startup.session";
      shell = "${pkgs.zsh}/bin/zsh --login --interactive";
    };
    theme = "One Half Dark"; # or Dracula or OneDark see https://github.com/kovidgoyal/kitty-themes/tree/master/themes
    # extraConfig = "\n";
  };
  home.file.".config/kitty/startup.session".text = ''
    new_tab
    cd ~
    launch zsh

    new_tab notes
    cd ~/Library/Containers/co.noteplan.NotePlan3/Data/Library/Application Support/co.noteplan.NotePlan3
    launch zsh

    new_tab news
    layout grid
    launch zsh -i -c tickrs
    launch zsh
    launch zsh -i -c "watch -n 120 -c \"/opt/homebrew/bin/icalBuddy -tf %H:%M -n -f -eep notes -ec 'Outschool Schedule,HomeAW,Contacts,Birthdays,Found in Natural Language' eventsToday\""
    launch zsh -i -c hackernews_tui
    new_tab svelte
    cd ~/src/icl/website/website-svelte-branch
  '';
  programs.alacritty = {
    enable = true;
    package =
      pkgs.alacritty; # switching to unstable so i get 0.11 with undercurl support
    settings = {
      window.decorations = "full";
      window.dynamic_title = true;
      #background_opacity = 0.9;
      window.opacity = 0.9;
      scrolling.history = 3000;
      scrolling.smooth = true;
      font.normal.family = "MesloLGS Nerd Font Mono";
      font.normal.style = "Regular";
      font.bold.style = "Bold";
      font.italic.style = "Italic";
      font.bold_italic.style = "Bold Italic";
      font.size =
        if pkgs.stdenvNoCC.isDarwin
        then 16
        else 9;
      shell.program = "${pkgs.zsh}/bin/zsh";
      live_config_reload = true;
      cursor.vi_mode_style = "Underline";
      draw_bold_text_with_bright_colors = true;
      key_bindings = [
        {
          key = "Escape";
          mods = "Control";
          mode = "~Search";
          action = "ToggleViMode";
        }
        # cmd-{ and cmd-} and cmd-] and cmd-[ will switch tmux windows
        {
          key = "LBracket";
          mods = "Command";
          # \x02 is ctrl-b so sequence below is ctrl-b, h
          chars = "\\x02h";
        }
        {
          key = "RBracket";
          mods = "Command";
          chars = "\\x02l";
        }
      ];
    };
  };
}
