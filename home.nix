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
    ranger
    du-dust
    glow
    bottom
    exif
    niv
    youtube-dl
  ];
  luaPkgs = with pkgs; [ sumneko-lua-language-server luaformatter ];
  nixEditorPkgs = with pkgs; [ nixfmt rnix-lsp ];
  rustPkgs = with pkgs; [
    cargo
    rustfmt
    rust-analyzer
    rustc
    gcc
    gnumake
    pkg-config
    glib
  ];
  typescriptPkgs = with pkgs.nodePackages; [
    typescript
    typescript-language-server
    diagnostic-languageserver
    eslint_d
  ];
  networkPkgs = with pkgs; [ traceroute mtr iftop ];
  guiPkgs = with pkgs; [
    neovide
    xss-lock
    i3-auto-layout
    mpv
    keepassxc
    syncthingtray-minimal
    spotify-qt
  ];
  browser = [ "qutebrowser.desktop" ];
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

  home.packages = defaultPkgs ++ luaPkgs ++ nixEditorPkgs ++ rustPkgs
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
  home.file.".wallpaper.jpg".source = ./home/wallpaper/castle2.jpg;
  home.file.".lockpaper.png".source = ./home/wallpaper/kali.png;
  #home.file.".config/touchegg/touchegg.conf".source = ./home/dotfiles/touchegg.conf;

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
  programs.broot = {
    enable = true;
    modal = true;
    verbs = [
      {
        execution = ":parent";
        invocation = "p";
      }
      {
        execution = "$VISUAL {file}";
        invocation = "edit";
        shortcut = "e";
      }
      {
        execution = "$EDITOR {directory}/{subpath}";
        invocation = "create {subpath}";
      }
      {
        execution = "bat {file}";
        invocation = "view";
      }
    ];
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
      size = 8;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      #name = "Breeze Dark";
      #package = pkgs.gnome-breeze;
    };
  };

  programs.qutebrowser.enable = true;
  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      https-everywhere
      noscript
      vimium
    ];
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window.decorations = "full";
      window.dynamic_title = true;
      background_opacity = 0.9;
      scrolling.history = 3000;
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
      key_bindings = [{
        key = "Escape";
        mods = "Control";
        mode = "~Search";
        action = "ToggleViMode";
      }];
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
      fd = "fd -HI"; # when calling the command, search all
      f = "fd"; # default search this dir for files ignoring .gitignore etc
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
    ignores = [
      "$RECYCLE.BIN/"
      "*$py.class"
      "**/*.rs.bk"
      "**/linux_mysql/*.d"
      "**/target"
      "*,cover"
      "*-journal"
      "*-session.json"
      "*.Cache"
      "*.DS_Store"
      "*.a"
      "*.back"
      "*.backup"
      "*.bak"
      "*.cache"
      "*.class"
      "*.clbin"
      "*.compiled.js"
      "*.d"
      "*.dSYM"
      "*.dSYM/"
      "*.dll"
      "*.dmp"
      "*.dump"
      "*.dylib"
      "*.elf"
      "*.exe"
      "*.hex"
      "*.idb"
      "*.kate-swp"
      "*.kicad_pcb-bak"
      "*.ko"
      "*.komodoproject"
      "*.la"
      "*.launch"
      "*.lib"
      "*.lnk"
      "*.lo"
      "*.lock"
      "*.log"
      "*.manifest"
      "*.map"
      "*.ncb"
      "*.o"
      "*.o.d"
      "*.obj"
      "*.old"
      "*.orig"
      "*.out"
      "*.pbxuser"
      "*.pdb"
      "*.perspectivev3"
      "*.pid"
      "*.pid.lock"
      "*.py[cdo]"
      "*.py[co]"
      "*.py[cod]"
      "*.pyc"
      "*.pydevproject"
      "*.pyo"
      "*.py~"
      "*.sfd~"
      "*.so"
      "*.so.*"
      "*.sublime*"
      "*.sublime-*"
      "*.sublime-workspace"
      "*.suit"
      "*.suo"
      "*.sw*"
      "*.swn"
      "*.swo"
      "*.swp"
      "*.tlh"
      "*.tli"
      "*.tmp"
      "*.trace"
      "*.un~"
      "*.user"
      "*.vsp"
      "*.vspscc"
      "*.xccheckout"
      "*.xcodeproj/"
      "*.xcuserstate"
      "*.xcworkspace"
      "*/**/.DS_Store"
      "*_generated.phph"
      "*~"
      "*~.DS_STORE"
      "*~.nib"
      ".#*"
      ".*.sw*"
      ".*.swo"
      ".*.swp"
      ".AppleDB"
      ".AppleDesktop"
      ".AppleDouble"
      ".CREATED"
      ".DS_Store"
      ".DocumentRevisions-V100"
      ".LSOverride"
      ".Python"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Thumbs.db"
      ".Trash-*"
      ".Trashes"
      ".VolumeIcon.icns"
      "._*"
      ".apdisk"
      ".build/"
      ".buildpath"
      ".builds"
      ".bundle"
      ".cache"
      ".cargo"
      ".classpath"
      ".com.apple.timemachine.donotpresent"
      ".coverage"
      ".coverage.*"
      ".cproject"
      ".depend"
      ".deps"
      ".dirstamp"
      ".dotcloud"
      ".dropbox"
      ".dropbox-cache"
      ".eggs/"
      ".eslintcache"
      ".externalToolBuilders/"
      ".flymake*"
      ".fseventsd"
      ".fuse_hidden*"
      ".gdb_history"
      ".git"
      ".git/"
      ".gitignore"
      ".gitkeep"
      ".gopath/"
      ".grunt"
      ".hg"
      ".hg/"
      ".hgignore"
      ".history"
      ".hypothesis/"
      ".idea"
      ".idea/"
      ".idea_modules"
      ".idea_modules/"
      ".metals"
      ".mypy_cache/"
      ".nb-gradle/"
      ".netrwhist"
      ".node_repl_history"
      ".npm"
      ".nyc_output"
      ".obsidian"
      ".output/*"
      ".pc/"
      ".pydevproject"
      ".pytest_cache/"
      ".python-version"
      ".res"
      ".ropeproject"
      ".sass-cache"
      ".sass-cache# Python stuff"
      ".sqlmap_history"
      ".svn"
      ".tags"
      ".tags_sorted_by_file"
      ".venv"
      ".vs/"
      ".vscode"
      ".vscode/"
      ".webassets-cache"
      ".yarn"
      ".yarn-integrity"
      "CVS"
      "Carthage/"
      "Debug"
      "Debug/"
      "DerivedData"
      "DerivedData/"
      "Desktop.ini"
      "Gemfile.lock"
      "GeneratedFiles/"
      "GitHub.sublime-settings"
      "Icon"
      ''
        Icon

      ''
      "MANIFEST"
      "MANIFEST.bak"
      "Network Trash Folder"
      "Release"
      "Release/"
      "Release_MD/"
      "SecureROM-*"
      "Temporary Items"
      "TestResults"
      "Thumbs.db"
      "[Bb]in"
      "[Dd]ebug/"
      "[Ee]xpress"
      "[Oo]bj"
      "[Rr]elease/"
      "_ReSharper*"
      "_UpgradeReport_Files/"
      "__handlers__/"
      "__pycache__"
      "__pycache__/"
      "_build/"
      "_tmp.txt"
      "a.out"
      "bin/linux_mysql"
      "bower_components"
      "build"
      "build/"
      "bundles/"
      "cache"
      "cache/"
      "config.cache"
      "debug.log"
      "dist/"
      "docs/_build"
      "docs/_build/"
      "docs/_static"
      "docs/_templates"
      "makefiles"
      "mod_info.phph"
      "node_modules"
      "obj"
      "out"
      "output.txt"
      "output/"
      "parser.out"
      "project/boot/"
      "project/plugins/"
      "project/target"
      "release/"
      "release32/"
      "release64/"
      "tags"
      "tags-php"
      "target"
      "target/"
      "tmp"
      "tmp/"
      "tmp/**"
      "vendor/"
      "~$*"
      "~/.config/pianobar/config"
      "~/.gitignore"

    ];
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
      names = [ "DejaVu Sans Mono" ];
      size = 2.0;
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
      "${mod}+t" = "split toggle";
      "${mod}+s" = "layout stacking";
      "${mod}+w" = "layout tabbed";
      "${mod}+e" = "layout toggle split";
      "${mod}+m" = "move scratchpad";
      "${mod}+o" = "scratchpad show";
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
    exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork -i ~/.lockpaper.png
    exec_always --no-startup-id i3-auto-layout
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
    FZF_CTRL_R_OPTS = "--sort --exact";
    BROWSER = "qutebrowser";
    TERMINAL = "alacritty";
  };
}
