{ config, ... }:

let
  sources = import nix/sources.nix;
  pkgs-unstable = import sources.nixpkgs { config = { allowUnfree = true; }; };
  #nixos-unstable = import sources.nixos { config = { allowUnfree = true; }; };
  powerlevel10k = sources.powerlevel10k;
  gitstatus = sources.gitstatus;

  defaultPkgs = with pkgs-unstable; [ fd fzy tree-sitter ripgrep ];
  luaPkgs = with pkgs-unstable; [ sumneko-lua-language-server luaformatter ];
  nixEditorPkgs = with pkgs-unstable; [ nixfmt rnix-lsp ];
  rustPkgs = with pkgs-unstable; [ cargo rustfmt rust-analyzer rustc ];
  typescriptPkgs = with pkgs-unstable.nodePackages; [
    typescript
    typescript-language-server
    diagnostic-languageserver
    eslint_d
  ];

in {

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "root";
  home.homeDirectory = "/root";

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
    ++ typescriptPkgs;

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bat.enable = true;
  programs.broot.enable = true;
  programs.nix-index.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
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

    plugins = with pkgs-unstable.vimPlugins; [
      # Syntax / Language Support ##########################
      vim-polyglot
      #rust-vim # this is included in vim-polyglot
      rust-tools-nvim
      popup-nvim
      crates-nvim
      nvim-lspconfig
      lspsaga-nvim
      lspkind-nvim
      lsp_signature-nvim
      lsp-colors-nvim
      nvim-lsp-ts-utils
      trouble-nvim
      telescope-nvim
      telescope-fzy-native-nvim
      telescope-frecency-nvim
      neoformat

      # UI #################################################
      #onedarkpro-nvim # colorscheme
      onedark-vim # colorscheme
      nvim-colorizer-lua # color over CSS like #00ff00
      nvim-web-devicons
      nvim-tree-lua
      gitsigns-nvim # status in gutter
      symbols-outline-nvim
      lualine-nvim
      barbar-nvim
      indent-blankline-nvim
      toggleterm-nvim
      nvim-treesitter

      # Editor Features ####################################
      vim-abolish
      vim-surround
      vim-unimpaired
      vim-repeat
      vim-rsi
      vim-visualstar
      kommentary
      vim-eunuch

      # Autocompletion
      nvim-cmp
      cmp-nvim-lua
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-emoji
      nvim-autopairs

      plenary-nvim # Library for lua plugins
      vim-fugitive
      vim-rooter
    ];
  };
  home.file."${config.xdg.configHome}/nvim/parser/tsx.so".source =
    "${pkgs-unstable.tree-sitter.builtGrammars.tree-sitter-tsx}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/nix.so".source =
    "${pkgs-unstable.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/vim.so".source =
    "${pkgs-unstable.tree-sitter.builtGrammars.tree-sitter-vim}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/lua.so".source =
    "${pkgs-unstable.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/css.so".source =
    "${pkgs-unstable.tree-sitter.builtGrammars.tree-sitter-css}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/yaml.so".source =
    "${pkgs-unstable.tree-sitter.builtGrammars.tree-sitter-yaml}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/toml.so".source =
    "${pkgs-unstable.tree-sitter.builtGrammars.tree-sitter-toml}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/rust.so".source =
    "${pkgs-unstable.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/json.so".source =
    "${pkgs-unstable.tree-sitter.builtGrammars.tree-sitter-json}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/typescript.so".source =
    "${pkgs-unstable.tree-sitter.builtGrammars.tree-sitter-typescript}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/javascript.so".source =
    "${pkgs-unstable.tree-sitter.builtGrammars.tree-sitter-javascript}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/bash.so".source =
    "${pkgs-unstable.tree-sitter.builtGrammars.tree-sitter-bash}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/scala.so".source =
    "${pkgs-unstable.tree-sitter.builtGrammars.tree-sitter-scala}/parser";

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };
  programs.gh.enable = true;
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
    shell = "${pkgs-unstable.zsh}/bin/zsh";
    historyLimit = 10000;
    escapeTime = 0;
    extraConfig = ''
      ${builtins.readFile ./home/dotfiles/tmux.conf}
    '';
    sensibleOnTop = true;
    plugins = with pkgs-unstable; [
      tmuxPlugins.sensible
      tmuxPlugins.open
      {
        plugin = tmuxPlugins.fzf-tmux-url;
        extraConfig = ''
          set -g @fzf-url-history-limit '200'
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
  };
}
