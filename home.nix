{ config, pkgs, powerlevel10k, gitstatus, lib, ... }:

let
  #sources = import nix/sources.nix;
  #pkgs = import sources.nixpkgs { config = { allowUnfree = true; }; };
  #powerlevel10k = sources.powerlevel10k;
  #gitstatus = sources.gitstatus;

  defaultPkgs = with pkgs; [
    fd
    fzy
    tree-sitter
    ripgrep
    curl
    atool
    file
    ranger
    du-dust
    lf # file explorer
    highlight # code coloring in lf
    poppler_utils # for pdf2text in lf
    mediainfo
    exiftool
    ueberzug # for terminal image previews
    glow # view markdown file or dir
    mdcat # colorize markdown
    vimv # shell script to bulk rename
    html2text
    bottom
    exif
    niv
    youtube-dl
    vulnix # check for live nix apps that are listed in NVD
    tickrs
  ];
  cPkgs = with pkgs; [
    automake
    autoconf
    gcc
    gnumake
    pkg-config
    nasm
    glib
    libtool
    libpng
    libjpeg
    sqlite
  ];
  luaPkgs = with pkgs; [ sumneko-lua-language-server luaformatter ];
  nixEditorPkgs = with pkgs; [ nixfmt rnix-lsp ];
  rustPkgs = with pkgs; [ cargo rustfmt rust-analyzer rustc ];
  typescriptPkgs = with pkgs.nodePackages; [
    typescript
    typescript-language-server
    yarn
    diagnostic-languageserver
    eslint_d
  ];
  networkPkgs = with pkgs; [ traceroute mtr iftop ];
  guiPkgs = with pkgs; [
    neovide
    xss-lock
    i3-auto-layout
    keepassxc
    syncthingtray-minimal
    spotify-qt
    slack
    discord
  ];

  browser = [ "org.qutebrowser.qutebrowser.desktop" ];
  associations = {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/chrome" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;

    "text/*" = [ "neovide.desktop" ];
    "audio/*" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.dekstop" ];
    "image/*" = [ "feh.desktop" ];
    "application/json" = browser; # ".json"  JSON format
    "application/pdf" = browser; # ".pdf"  Adobe Portable Document Format (PDF)
  };

in {

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "zmre";
  home.homeDirectory = "/home/zmre";
  home.enableNixpkgsReleaseCheck = false;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  home.packages = defaultPkgs ++ cPkgs ++ luaPkgs ++ nixEditorPkgs ++ rustPkgs
    ++ typescriptPkgs ++ guiPkgs ++ networkPkgs;

  home.file.".p10k.zsh".source = ./home/dotfiles/p10k.zsh;
  home.file.".config/nvim/lua/options.lua".source =
    ./home/dotfiles/nvim/lua/options.lua;
  home.file.".config/nvim/lua/abbreviations.lua".source =
    ./home/dotfiles/nvim/lua/abbreviations.lua;
  home.file.".config/nvim/lua/filetypes.lua".source =
    ./home/dotfiles/nvim/lua/filetypes.lua;
  home.file.".config/nvim/lua/mappings.lua".source =
    ./home/dotfiles/nvim/lua/mappings.lua;
  home.file.".config/nvim/lua/tools.lua".source =
    ./home/dotfiles/nvim/lua/tools.lua;
  home.file.".config/nvim/lua/plugins.lua".source =
    ./home/dotfiles/nvim/lua/plugins.lua;
  home.file.".config/nvim/vim/colors.vim".source =
    ./home/dotfiles/nvim/vim/colors.vim;
  home.file.".config/lf/lfrc".source = ./home/dotfiles/lfrc;
  home.file.".config/lf/previewer.sh".source = ./home/dotfiles/previewer.sh;
  home.file.".config/lf/pager.sh".source = ./home/dotfiles/pager.sh;
  home.file.".config/lf/lficons.sh".source = ./home/dotfiles/lficons.sh;
  home.file.".wallpaper.jpg".source = ./home/wallpaper/castle2.jpg;
  home.file.".lockpaper.png".source = ./home/wallpaper/kali.png;
  #home.file.".tmux.conf".source =
  #"${config.home-manager-files}/.config/tmux/tmux.conf";
  #home.file.".gitignore".source =
  #"${config.home-manager-files}/.config/git/ignore";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style =
        "plain"; # no line numbers, git status, etc... more like cat with colors
    };
  };
  programs.mpv.enable = true;
  programs.mpv.scripts = with pkgs.mpvScripts; [ thumbnail sponsorblock ];
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
    enable = true;
    colorTheme = "dark-256";
    dataLocation = "$HOME/.task";
    config = {
      urgency.user.tag.networking.coefficient = -10.0;
      uda.reviewed.type = "date";
      uda.reviewed.label = "Reviewed";
      report._reviewed.description =
        "Tasksh review report.  Adjust the filter to your needs.";
      report._reviewed.columns = "uuid";
      report._reviewed.sort = "reviewed+,modified+";
      report._reviewed.filter =
        "( reviewed.none: or reviewed.before:now-6days ) and ( +PENDING or +WAITING )";
      search.case.sensitive = "no";
      # Shortcuts
      alias.dailystatus = "status:completed end.after:today all";
      alias.punt = "modify wait:1d";
      alias.someday = "mod +someday wait:someday";

      # task ready report default with custom columns
      default.command = "ready";
      report.ready.columns =
        "id,start.active,depends.indicator,project,due.relative,description.desc";
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

  gtk = {
    enable = true;

    font = {
      name = "FiraCode Nerd Font";
      size = 9;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      #name = "Breeze Dark";
      #package = pkgs.gnome-breeze;
    };
  };

  programs.qutebrowser = {
    enable = true;
    keyBindings = {
      normal = {
        ",m" = "spawn mpv {url}";
        ",M" = "hint links spawn mpv {hint-url}";
        ",d" = "spawn youtube-dl -o ~/Downloads/%(title)s.%(ext)s {url}')";
        ",f" = "spawn firefox {url}";
        "xt" = "config-cycle tabs.show always never";
        "<f12>" = "inspector";
      };
      prompt = { "<Ctrl-y>" = "prompt-yes"; };
    };
    settings = {
      confirm_quit = [ "downloads" ]; # only confirm if downloads in progress
      content.blocking.enabled = true;
      content.blocking.method = "both";
      content.blocking.hosts.block_subdomains = true;
      content.default_encoding = "utf-8";
      content.geolocation = false;
      content.cookies.accept = "no-3rdparty";
      content.webrtc_ip_handling_policy = "default-public-interface-only";
      content.javascript.can_access_clipboard = true;
      content.site_specific_quirks.enabled = false;
      content.headers.user_agent =
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36";
      content.pdfjs = true;
      content.autoplay = false;
      scrolling.smooth = true;
      auto_save.session = true; # remember open tabs
      # if input is focused on tab load, allow typing
      input.insert_mode.auto_load = true;
      # exit insert mode if clicking on non editable item
      input.insert_mode.auto_leave = true;
      downloads.location.directory = "${config.home.homeDirectory}/Downloads";
      downloads.location.prompt = false;
      downloads.position = "bottom";
      downloads.remove_finished = 10000;
      completion.use_best_match = true;
      colors.webpage.preferred_color_scheme = "dark";
      colors.webpage.darkmode.enabled = true;
      colors.tabs.bar.bg = "#333333";
      colors.webpage.bg = "black";
      statusbar.widgets = [ "progress" "keypress" "url" "history" ];
      tabs.position = "left";
      tabs.title.format = "{index}: {audio}{current_title}";
      tabs.title.format_pinned = "{index}: {audio}{current_title}";
      tabs.last_close = "close";
      spellcheck.languages = [ "en-US" ];
      editor.command = [ "neovide" "{}:{line}" ];
      fileselect.handler = "external";
      fileselect.single_file.command = [
        "alacritty"
        "--class"
        "lf,lf"
        "-t"
        "Chooser"
        "-e"
        "sh"
        "-c"
        "lf -selection-path {}"
      ];
      fileselect.multiple_files.command = [
        "alacritty"
        "--class"
        "lf,lf"
        "-t"
        "Chooser"
        "-e"
        "sh"
        "-c"
        "lf -selection-path {}"
      ];
    };
    quickmarks = {
      icc = "https://ironcorelabs.com/";
      icweb = "https://github.com/ironcorelabs/website";
      nix = "https://search.nixos.org/";
      hm = "https://nix-community.github.io/home-manager/options.html";
      rd = "https://reddit.com/";
      yt = "https://youtube.com/";
      hn = "https://news.ycombinator.com/";
      tw = "https://twitter.com/";
      td = "https://twitter.com/i/lists/44223630";
      gh = "https://github.com/";
      ghi = "https://github.com/ironcorelabs/";
      ghz = "https://github.com/zmre/";
      ghn = "https://github.com/notifications?participating=true";
      gr = "https://goodreads.com/";
      mg = "https://mail.google.com/";
      mp = "https://mail.protonmail.com/";
    };
    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?q={}&ia=web";
      d = "https://duckduckgo.com/?q={}&ia=web";
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      aw = "https://wiki.archlinux.org/?search={}";
      nw = "https://nixos.wiki/index.php?search={}";
      np =
        "https://search.nixos.org/packages?channel=21.11&from=0&size=100&sort=relevance&type=packages&query={}";
      nu =
        "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      no =
        "https://search.nixos.org/options?channel=21.11&from=0&size=50&sort=relevance&type=packages&query={}";
      nf =
        "https://search.nixos.org/flakes?channel=21.11&from=0&size=50&sort=relevance&type=packages&query={}";
      g = "https://www.google.com/search?hl=en&q={}";
      gh = "https://github.com/?q={}";
    };
  };

  programs.firefox = {
    enable = true;
    # turns out you have to setup a profile (below) for extensions to install
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      https-everywhere
      noscript
      vimium
    ];
    profiles.home.id = 0;
    profiles.home.settings = {
      "app.update.auto" = false; # nix will handle updates
      "browser.search.region" = "US";
      "browser.search.countryCode" = "US";
      "browser.ctrlTab.recentlyUsedOrder" = false;
      "browser.newtabpage.enhanced" = true;
      "devtools.chrome.enabled" = true;
      "network.prefetch-next" = true;
      "nework.predictor.enabled" = true;
      "browser.uidensity" = 1;
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.socialtracking.enabled" = true;
      "privacy.trackingprotection.socialtracking.annotate.enabled" = true;
      "privacy.trackingprotection.socialtracking.notification.enabled" = false;
      "services.sync.engine.addons" = false;
      "services.sync.engine.passwords" = false;
      "services.sync.engine.prefs" = false;
      "signon.rememberSignons" = false;
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window.decorations = "full";
      window.dynamic_title = true;
      background_opacity = 0.9;
      scrolling.history = 3000;
      scrolling.smooth = true;
      font.normal.family = "MesloLGS Nerd Font Mono";
      font.normal.style = "Regular";
      font.bold.style = "Bold";
      font.italic.style = "Italic";
      font.bold_italic.style = "Bold Italic";
      font.size = 9;
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

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      lua << 
          require('options').defaults()
          require('options').gui()
          require('mappings')
          require('abbreviations')
          require('filetypes').config()
          require('plugins')
      
    '';

    plugins = with pkgs.vimPlugins; [
      # Syntax / Language Support ##########################
      vim-polyglot # lazy load all the syntax plugins for all the languages
      #rust-vim # this is included in vim-polyglot
      rust-tools-nvim # lsp stuff and more for rust
      crates-nvim # inline intelligence for Cargo.toml
      nvim-lspconfig # setup LSP
      lspsaga-nvim # makes LSP stuff look nicer and easier to use
      lspkind-nvim # adds more icons into dropdown selections
      lsp_signature-nvim # as you type hitns on function parameters
      nvim-lsp-ts-utils # typescript lsp
      trouble-nvim # navigate all warnings and errors in quickfix-like window
      neoformat # autoformat on save, if formatter found

      # UI #################################################
      #onedarkpro-nvim # colorscheme
      onedark-vim # colorscheme
      telescope-nvim # da best popup fuzzy finder
      telescope-fzy-native-nvim # but fzy gives better results
      telescope-frecency-nvim # and frecency comes in handy too
      nvim-colorizer-lua # color over CSS like #00ff00
      nvim-web-devicons # makes things pretty; used by many plugins below
      nvim-tree-lua # file navigator
      gitsigns-nvim # git status in gutter
      symbols-outline-nvim # navigate the current file better
      lualine-nvim # nice status bar at bottom
      barbar-nvim # nice buffers (tabs) bar at top
      indent-blankline-nvim # visual indent
      toggleterm-nvim # better terminal management
      nvim-treesitter # better code coloring

      # Editor Features ####################################
      vim-abolish # better abbreviations / spelling fixer
      vim-surround # most important plugin for quickly handling brackets
      vim-unimpaired # bunch of convenient navigation key mappings
      vim-repeat # supports all of the above so you can use .
      vim-rsi # brings keyline bindings to editing (like ctrl-e for end of line when in insert mode)
      vim-visualstar # press * or # on a word to find it
      kommentary # code commenter
      vim-eunuch # brings cp/mv type commands. :Rename and :Move are particularly handy

      # Autocompletion
      nvim-cmp # generic autocompleter
      cmp-nvim-lua
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-emoji
      nvim-autopairs # balances parens as you type
      vim-emoji

      # Misc
      popup-nvim # dependency of some other plugins
      plenary-nvim # Library for lua plugins; used by many plugins here
      vim-fugitive # git management
      vim-rooter # change dir to project root
      vim-tmux-navigator # navigate vim and tmux panes together
    ];
  };
  home.file."${config.xdg.configHome}/nvim/parser/tsx.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-tsx}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/nix.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/vim.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-vim}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/lua.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/css.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-css}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/yaml.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-yaml}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/toml.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-toml}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/rust.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/json.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-json}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/typescript.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-typescript}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/javascript.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-javascript}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/bash.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-bash}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/scala.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-scala}/parser";

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };
  programs.ssh.enable = true;
  programs.gh = {
    enable = true;
    settings = { git_protocol = "ssh"; };
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      save = 10000; # save 10,000 lines of history
    };
    initExtraBeforeCompInit = ''
      source ${gitstatus.outPath}/gitstatus.plugin.zsh
      source ${powerlevel10k.outPath}/powerlevel10k.zsh-theme
    '';
    completionInit = ''
      autoload -U compinit && completionInit
    '';
    initExtra = ''
      if [[ -r "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh" ]]; then
        source "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh"
      fi

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

      # You might not like what I'm doing here, but '/' works like ctrl-r
      # and matches as you type. I've added pattern matches here though.

      bindkey -M vicmd '/' history-incremental-pattern-search-backward # default is vi-history-search-backward
      bindkey -M vicmd '?' vi-history-search-backward # default is vi-history-search-forward

      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd 'v' edit-command-line

      zstyle ':completion:*:manuals'    separate-sections true
      zstyle ':completion:*:manuals.*'  insert-sections   true
      zstyle ':completion:*:man:*'      menu yes select
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.zsh/cache
      zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
      zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
      zstyle ':completion:*:*:kill:*' menu yes select
      zstyle ':completion:*:kill:*'   force-list always

      # Customize fzf plugin to use fd
      # Should default to ignore anything in ~/.gitignore
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
      # Use fd (https://github.com/sharkdp/fd) instead of the default find
      # command for listing path candidates.
      # - The first argument to the function ($1) is the base path to start traversal
      # - See the source code (completion.{bash,zsh}) for the details.
      _fzf_compgen_path() {
        \fd --hidden --follow . "$1"
      }

      # Use fd to generate the list for directory completion
      _fzf_compgen_dir() {
        \fd --type d --hidden --follow . "$1"
      }

      # Needed for lf to be pretty
      . ~/.config/lf/lficons.sh

      # Prompt stuff
      source ${./home/dotfiles/p10k.zsh}
    '';
    plugins = [
      {
        name = "powerlevel10k";
        src = powerlevel10k;
      }
      {
        name = "powerlevel10k-config";
        src = ./home/dotfiles/p10k.zsh;
        file = "p10k.zsh";
      }
    ];
    oh-my-zsh.enable = true;
    oh-my-zsh.plugins = [
      "sudo"
      "gitfast"
      "vim-interaction"
      "docker"
      "taskwarrior"
      "tmux"
      "fzf"
      "cargo"
      "brew"
      "ripgrep"
      "vi-mode"
      "zoxide"
    ];
    shellAliases = {
      ls = "ls --color=auto -F";
      l = "exa --icons --git-ignore --git -F --extended";
      ll = "exa --icons --git-ignore --git -F --extended -l";
      lt = "exa --icons --git-ignore --git -F --extended -T";
      llt = "exa --icons --git-ignore --git -F --extended -l -T";
      fd = "\\fd -H -t d"; # default search directories
      f = "\\fd -H"; # default search this dir for files ignoring .gitignore etc
      nixosedit =
        "nvim /etc/nixos/configuration.nix ; sudo nixos-rebuild switch --flake ~/.config/nixpkgs/.#";
      nixedit =
        "nvim ~/.config/nixpkgs/home.nix ; sudo nixos-rebuild switch --flake ~/.config/nixpkgs/.#";
      kali = "x11docker -i -m --sudouser=nopasswd kali";
    };
  };

  programs.exa.enable = true;
  programs.git = {
    enable = true;
    userName = "Patrick Walsh";
    userEmail = "patrick.walsh@ironcorelabs.com";
    aliases = {
      tatus = "status";
      co = "checkout";
      br = "branch";
      st = "status -sb";
      wtf = "!git-wtf";
      lg =
        "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --topo-order --date=relative";
      gl =
        "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --topo-order --date=relative";
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
    extraConfig = {
      github.user = "zmre";
      color.ui = true;
      pull.rebase = true;
      merge.conflictstyle = "diff3";
      #credential.helper = "osxkeychain";
      diff.algorithm = "patience";
      protocol.version = "2";
      core.commitGraph = true;
      gc.writeCommitGraph = true;
    };
    delta = {
      enable = true;
      options = {
        syntax-theme = "Monokai Extended";
        line-numbers = true;
        navigate = true;
        side-by-side = true;
      };
    };
    #ignores = [ ".cargo" ];
    ignores = import home/dotfiles/gitignore.nix;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shell = "${pkgs.zsh}/bin/zsh";
    historyLimit = 10000;
    escapeTime = 0;
    extraConfig = ''
      ${builtins.readFile ./home/dotfiles/tmux.conf}
    '';
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
          set -g @resurrect-processes ':all:'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
    ];
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.associations.added = associations;
  xdg.mimeApps.defaultApplications = associations;

  services.dunst.enable = true; # notification daemon
  services.syncthing = {
    enable = true;
    tray.enable = false;
  };
  # top bar
  services.polybar = rec {
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      pulseSupport = true;
    };
    script = "${package}/bin/polybar dracula &";
    settings = {
      "colors" = {
        background = {
          text = "#282a36";
          alt = "#282a36";
        };
        foreground = {
          text = "#f8f8f2";
          alt = "#f8f8f2";
        };
        #primary = "#13f01e";
        #secondary = "#bd93f9";
        #alert = "#bd93f9";
        alert = "\${self.red}";

        yellow = "#ffe74c";
        green = "#50fa7b";
        red = "#ff5964";
        blue = "#35a7ff";
        navy = "#38618c";
        purple = "#f18cfa";
        orange = "#ffb86c";
        border = "#44465a";
        darkgray = "#282a36";
        white = "#f8f8f2";
      };
      "bar/dracula" = {
        #monitor = "DisplayPort-2";
        height = 28;
        enable.ipc = true;
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";
        line.size = 3;
        border = {
          #color = "#44465a";
          color = "\${colors.border}";
          bottom.size = 3;
        };
        padding = {
          left = 0;
          right = 2;
        };
        module.margin = {
          left = 1;
          right = 2;
        };
        font = [
          "FiraCode Nerd Font:pixelsize=12;1"
          #"Source Code Pro:pixelsize=12;1"
          #"Font Awesome 5 Free Solid:size=11;1"
          #"Font Awesome 5 Free Solid:size=10;1"
          #"Font Awesome 5 Brands Regular:size=11;1"
        ];
        modules = {
          left = "cpu memory temperature";
          center = "date";
          right = "wireless-network battery backlight pulseaudio powermenu";
        };
        cursor = {
          click = "pointer";
          scroll = "ns-resize";
        };
      };
      "module/battery" = {
        type = "internal/battery";
        battery = "BAT1";
        adapter = "ACAD";
        full-at = 98;
        label-charging = "%percentage%%";
        label-discharging = "%percentage%%";
        label-full = "Full";
        format = {
          text = "<label-full>";
          full = {
            prefix = {
              text = " ";
              foreground = "\${colors.green}";
            };
          };
          charging = {
            text = "<label-charging>";
            prefix = { text = " "; };
          };
          discharging = {
            # 
            text = "<ramp-capacity> <label-discharging>";
          };
        };
        ramp-capacity-0 = ""; # 10
        ramp-capacity-0-foreground = "\${colors.alert}";
        ramp-capacity-1 = ""; # 20
        ramp-capacity-1-foreground = "\${colors.alert}";
        ramp-capacity-2 = ""; # 30
        ramp-capacity-3 = ""; # 40
        ramp-capacity-4 = ""; # 50
        ramp-capacity-5 = ""; # 60
        ramp-capacity-6 = ""; # 70
        ramp-capacity-7 = ""; # 80
        ramp-capacity-8 = ""; # 90
        ramp-capacity-9 = "";
        ramp-capacity-9-foreground = "\${colors.green}";
      };
      "module/backlight" = {
        type = "internal/backlight";
        card = "intel_backlight";
        use-actual-brightness = true;
        label = "%percentage%%";
        format = {
          text = "<label>";
          prefix = {
            text = " ";
            foreground = "\${colors.yellow}";
          };
        };
      };
      "module/wireless-network" = {
        type = "internal/network";
        interface = "wlan0";
        #format-connected = "<label-connected>";
        format-disconnected = "<label-disconnected>";
        format-packetloss = {
          text = "<animation-packetloss> <label-connected>";
          foreground = "\${colors.alert}";
        };
        label-disconnected = "睊";
        format = {
          connected = {
            text = "<label-connected>";
            prefix = {
              text = "  ";
              foreground = "\${colors.purple}";
            };
          };
        };
        label-connected = "%essid% %signal%%";
      };
      "module/xkeyboard" = {
        type = "internal/xkeyboard";
        blacklist = [ "num lock" ];
        format = {
          text = "<label-layout><label-indicator>";
          spacing = 0;
          prefix = {
            text = " ";
            foreground = "\${colors.orange}";
          };
        };
        label = {
          layout = "%layout%";
          indicator.on = " %name%";
        };
      };
      "module/cpu" = {
        type = "internal/cpu";
        format = "<label> <ramp-coreload>";
        label = " %percentage%%";
        ramp-coreload-spacing = 1;
        ramp-coreload-0 = "▁";
        ramp-coreload-1 = "▂";
        ramp-coreload-2 = "▃";
        ramp-coreload-3 = "▄";
        ramp-coreload-4 = "▅";
        ramp-coreload-4-foreground = "\${colors.yellow}";
        ramp-coreload-5 = "▆";
        ramp-coreload-5-foreground = "\${colors.yellow}";
        ramp-coreload-6 = "▇";
        ramp-coreload-6-foreground = "\${colors.alert}";
        ramp-coreload-7 = "█";
        ramp-coreload-7-foreground = "\${colors.alert}";
      };
      "module/memory" = {
        type = "internal/memory";
        interval = 3;
        format = "<label> <bar-used>";
        label = " %gb_used%";
        bar-used-width = 30;
        bar-used-indicator = "";
        bar-used-foreground-0 = "\${colors.green}";
        bar-used-foreground-1 = "#557755";
        bar-used-foreground-2 = "\${colors.yellow}";
        bar-used-foreground-3 = "\${colors.alert}";
        bar-used-fill = "▐";
        bar-used-empty = "▐";
        bar-used-empty-foreground = "#444444";
      };
      "module/temperature" = {
        type = "internal/temperature";
        interval = 10;
        hwmon-path =
          "/sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input";
        base-temperature = 20; # celsius
        warn-temperature = 60;
        units = true;
        format = "<ramp> <label>";
        format-warn = "<ramp> <label-warn>";
        label = "%temperature-f%";
        label-warn = "%temperature-f%";
        label-warn-foreground = "\${colors.alert}";
        ramp-0 = "";
        ramp-1 = "";
        ramp-2 = "";
        ramp-foreground = "\${colors.yellow}";
      };
      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = {
          text = "";
          alt = " %m/%d/%y";
        };
        time = {
          text = " %I:%M %P ";
          alt = " %I:%M %P";
        };
        format = {
          prefix.foreground = "\${colors.foreground-alt}";
          padding = 0.5;
        };
        label = "%date% %time%";
      };
      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        format-volume = "<ramp-volume> <label-volume>";
        ramp-volume-0 = "奄";
        ramp-volume-0-foreground = "\${colors.blue}";
        ramp-volume-1 = "奔";
        ramp-volume-1-foreground = "\${colors.blue}";
        ramp-volume-2 = "墳";
        ramp-volume-2-foreground = "\${colors.blue}";
        ramp-volume-3 = " ";
        ramp-volume-3-foreground = "\${colors.blue}";

        label = {
          volume = "%percentage%";
          muted = {
            text = "婢";
            foreground = "\${colors.blue}";
          };
        };
      };
      "module/powermenu" = {
        type = "custom/menu";
        expand.right = true;
        format.spacing = 1;
        label = {
          open = {
            text = "%{T3}";
            foreground = "\${colors.navy}";
          };
          close = {
            text = "%{T2}";
            foreground = "\${colors.red}";
          };
          separator = {
            text = "|";
            foreground = "\${colors.foreground-alt}";
          };
        };
        menu = [
          [
            {
              text = "%{T3} ";
              exec = "menu-open-1";
            }
            {
              text = "%{T3}";
              exec = "menu-open-2";
            }
          ]
          [
            {
              text = "%{T2}";
              exec = "menu-open-0";
            }
            {
              text = "%{T3} ";
              exec = "sudo ${pkgs.systemd}/bin/reboot now";
            }
          ]
          [
            {
              text = "%{T3}";
              exec = "sudo ${pkgs.systemd}/bin/poweroff";
            }
            {
              text = "%{T2}";
              exec = "menu-open-0";
            }
          ]
        ];
      };
      "settings" = { screenchange.reload = true; };
      "wm" = {
        margin = {
          top = 5;
          bottom = 5;
        };
      };
    };
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
  # manage audio play/pause
  services.playerctld.enable = true;
  services.spotifyd.enable = true;

  services.picom.enable = true; # xsession compositor
  xsession.windowManager.i3.enable = true;
  xsession.windowManager.i3.config = {
    terminal = "${pkgs.alacritty}/bin/alacritty";
    modifier = "Mod4";
    menu =
      ''"${pkgs.rofi}/bin/rofi -modi drun -show drun -theme glue_pro_blue"'';
    # need to use i3-gaps package to use these
    gaps.inner = 4;
    gaps.outer = 2;
    gaps.smartBorders = "on";
    gaps.smartGaps = true;
    fonts = {
      names = [ "pango:SauceCodePro Nerd Font" ];
      size = 6.0;
    };
    focus.newWindow = "focus";
    focus.followMouse = false;
    window.border = 3;
    colors.focused = {
      background = "#285577";
      border = "#4c7899";
      childBorder = "#285577";
      indicator = "#2e9ef4";
      text = "#ffffff";
    };
    keybindings = let
      mod = config.xsession.windowManager.i3.config.modifier;
      refresh = "killall -SIGUSR1 i3status-rs";
    in lib.mkOptionDefault {
      "${mod}+Return" = "exec alacritty";
      "${mod}+j" = "focus left";
      "${mod}+k" = "focus down";
      "${mod}+l" = "focus up";
      "${mod}+Tab" = ''
        exec --no-startup-id "${pkgs.rofi}/bin/rofi -modi drun -show window -theme iggy"'';
      "${mod}+semicolon" = "focus right";
      "${mod}+Shift+j" = "move left";
      "${mod}+Shift+k" = "move down";
      "${mod}+Shift+l" = "move up";
      "${mod}+Shift+semicolon" = "move right";
      "${mod}+h" = "split h";
      "${mod}+v" = "split v";
      "${mod}+t" = "layout tabbed";
      "${mod}+s" = "layout stacking";
      "${mod}+w" = "layout default";
      "${mod}+e" = "layout toggle split tabbed stacking splitv splith";
      "${mod}+m" = "move scratchpad";
      "${mod}+o" = "scratchpad show";
      "${mod}+p" = "floating toggle";
      "${mod}+Shift+p" = ''[class="KeePassXC"] scratchpad show'';
      "${mod}+x" = "move workspace to output next";
      "${mod}+Ctrl+Right" = "workspace next";
      "${mod}+Ctrl+Left" = "workspace prev";
      "${mod}+F9" = "exec i3lock --nofork -i ~/.lockpaper.png";
      # Use pactl to adjust volume in PulseAudio.
      "XF86AudioRaiseVolume" =
        "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5% && ${refresh}";
      "XF86AudioLowerVolume" =
        "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5% && ${refresh}";
      "XF86AudioMute" =
        "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle && ${refresh}";
      "XF86AudioMicMute" =
        "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle && ${refresh}";
      "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play";
      "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";
      "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
      "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl prev";
      # backlight
      "XF86MonBrightnessUp" =
        "exec --no-startup-id ${pkgs.light}/bin/light -A 1";
      "XF86MonBrightnessDown" =
        "exec --no-startup-id ${pkgs.light}/bin/light -U 1";
    };
    defaultWorkspace = "workspace number 1";
    assigns = {
      "1: term" = [{ class = "^Alacritty$"; }];
      "2: web" = [{ class = "^(Firefox|qutebrowser)$"; }];
    };
    modes = {
      resize = {
        Down = "resize grow height 10 px or 10 ppt";
        Left = "resize shrink width 10 px or 10 ppt";
        Right = "resize grow width 10 px or 10 ppt";
        Up = "resize shrink height 10 px or 10 ppt";
        k = "resize grow height 10 px or 10 ppt";
        j = "resize shrink width 10 px or 10 ppt";
        semicolon = "resize grow width 10 px or 10 ppt";
        l = "resize shrink height 10 px or 10 ppt";
        Escape = "mode default";
        Return = "mode default";
      };
    };
    #bars.status_command = "i3status-rs";
    #bar.i3bar_command = "";
    #bars.workspace_buttons = true;
    #bars.strip_workspace_numbers = false;
    startup = [
      {
        command = "systemctl --user restart polybar";
        always = true;
        notification = false;
      }
      {
        command = "systemctl --user restart syncthing";
        always = true;
        notification = false;
      }
      {
        command = "feh --bg-fill ~/.wallpaper.jpg";
        always = true;
        notification = false;
      }
      # NetworkManager is the most popular way to manage wireless networks on Linux,
      # and nm-applet is a desktop environment-independent system tray GUI for it.
      {
        command = "nm-applet";
        notification = false;
      }
      {
        command = "syncthingtray";
        always = true;
        notification = false;
      }
      { command = "qutebrowser"; }
      { command = "alacritty"; }
      { command = "keepassxc"; }
    ];
  };
  # xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
  # screen before suspend. Use loginctl lock-session to lock your screen.
  xsession.windowManager.i3.extraConfig = ''
    default_orientation auto
    exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork -i ~/.lockpaper.png
    exec_always --no-startup-id i3-auto-layout
    for_window [title="Chooser"] floating enable
    for_window [class="KeePassXC"] move scratchpad
  '';
  programs.i3status-rust.enable = true;
  programs.i3status-rust.bars = {
    bottom = {
      blocks = [
        {
          block = "disk_space";
          path = "/";
          alias = "/";
          info_type = "available";
          unit = "GB";
          interval = 60;
          warning = 20.0;
          alert = 10.0;
        }
        {
          block = "memory";
          display_type = "memory";
          format_mem = "{mem_used_percents}";
          format_swap = "{swap_used_percents}";
        }
        {
          block = "cpu";
          interval = 1;
        }
        {
          block = "load";
          interval = 1;
          format = "{1m}";
        }
        { block = "sound"; }
        {
          block = "time";
          interval = 60;
          format = "%a %d/%m %R";
        }
      ];
      settings = {
        theme = {
          name = "solarized-dark";
          overrides = {
            idle_bg = "#123456";
            idle_fg = "#abcdef";
          };
        };
      };
      icons = "awesome5";
      theme = "gruvbox-dark";
    };
  };

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    TERM = "xterm-256color";
    KEYTIMEOUT = 1;
    EDITOR = "nvim";
    VISUAL = "nvim";
    GIT_EDITOR = "nvim";
    LS_COLORS =
      "no=00:fi=00:di=01;34:ln=35;40:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:";
    LSCOLORS = "ExfxcxdxCxegedabagacad";
    FIGNORE = "*.o:~:Application Scripts:CVS:.git";
    TZ = "America/Denver";
    LESS =
      "--raw-control-chars -FXRadeqs -P--Less--?e?x(Next file: %x):(END).:?pB%pB%.";
    CLICOLOR_FORCE = "yes";
    PAGER = "less";
    # Add colors to man pages
    MANPAGER = "less -R --use-color -Dd+r -Du+b +Gg -M -s";
    SYSTEMD_COLORS = "true";
    FZF_CTRL_R_OPTS = "--sort --exact";
    BROWSER = "qutebrowser";
    TERMINAL = "alacritty";
    #LIBVA_DRIVER_NAME="iHD";
  };
}
