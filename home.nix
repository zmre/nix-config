{ config, pkgs, ... }:

{

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "pwalsh";
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

  home.packages = with pkgs; [
    cargo
    direnv
    exa
    fd
    fzy
    git
    nixfmt
    rnix-lsp
    ripgrep
    taskwarrior
    zoxide
    zsh-powerlevel10k
  ];

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
  home.file.".config/nvim/vim/colors.vim".source =
    ./home/dotfiles/nvim/vim/colors.vim;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bat.enable = true;
  programs.broot.enable = true;
  programs.nix-index.enable = true;

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
      
    '';
    #extraConfig = builtins.readFile ./home/extraConfig.vim;
    #extraConfig = let
    #luaRequire = module: builtins.readFile (builtins.toString 
    #./home/dotfiles + "/${module}.lua");
    #luaConfig = builtins.concatStringsSep "\n" (map luaRequire [
    #"options"
    #"mappings"
    #"abbreviations"
    #"filetypes"
    ##]);
    #in ''
    #lua << 
    #${luaConfig}
    #
    #'';

    plugins = with pkgs.vimPlugins; [
      # Syntax / Language Support ##########################
      # vim-gvpr           # gvpr
      rust-vim # rust
      telescope-nvim
      telescope-z-nvim
      telescope-fzy-native-nvim
      telescope-frecency-nvim
      gitsigns-nvim

      # UI #################################################
      onedarkpro-nvim # colorscheme
      vim-gitgutter # status in gutter
      # vim-devicons
      #vim-airline

      # Editor Features ####################################
      vim-abolish
      vim-surround # cs"'
      vim-unimpaired
      vim-repeat # cs"'...
      vim-rsi
      kommentary
      crates-nvim
      vim-polyglot
      vim-eunuch # :Rename foo.rb

      vim-fugitive # Gblame
    ];
  };

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
    #enableFzfHistory = true;
    enableSyntaxHighlighting = true;
    #enableFzfGit = true;
    #autosuggestions.enable = true;
    #autosuggestions.extraConfig.ZSH_AUTOSUGGEST_USE_ASYNC = "y";
    #histSize = 100000;
    #syntaxHighlighting.enable = true;
    #syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "root" "line" ];
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
      "zoxide"
    ];
    oh-my-zsh.theme =
      "../../../../../../../../$HOME/.nix-profile/share/zsh-powerlevel10k/powerlevel10k";
    #oh-my-zsh.theme = "muse";
    shellAliases = {
      ls = "ls --color=auto -F";
      l = "exa --icons --git-ignore --git -F --extended";
      ll = "exa --icons --git-ignore --git -F --extended -l";
      lt = "exa --icons --git-ignore --git -F --extended -T";
      llt = "exa --icons --git-ignore --git -F --extended -l -T";
      fd = "fd -HI"; # when calling the command, search all
      f = "fd"; # default search this dir for files ignoring .gitignore etc
    };

    #setOptions = [
    #"DISABLE_COMPFIX"
    #"HYPHEN-INSENSITIVE"
    #"list_ambiguous"
    #"vi"
    #"noautomenu"
    #"nomenucomplete"
    #"AUTO_CD"
    #"BANG_HIST"
    #"EXTENDED_HISTORY"
    #"HIST_EXPIRE_DUPS_FIRST"
    #"HIST_FIND_NO_DUPS"
    #"HIST_IGNORE_ALL_DUPS"
    #"HIST_IGNORE_DUPS"
    #"HIST_IGNORE_SPACE"
    #"HIST_REDUCE_BLANKS"
    #"HIST_SAVE_NO_DUPS"
    #"INC_APPEND_HISTORY"
    #"SHARE_HISTORY"
    #];
  };

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
      credential.helper = "osxkeychain";
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
    #enableSensible = true;
    #enableMouse = true;
    #enableFzf = true;
    #enableVim = true;
    keyMode = "vi";
    shell = "${pkgs.zsh}/bin/zsh";
    historyLimit = 10000;
    escapeTime = 0;
    #extraConfig = builtins.readFile "./home/dotfiles/tmux.conf";
    extraConfig = ''
      ${builtins.readFile ./home/dotfiles/tmux.conf}
    '';
  };

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    TERM = "xterm-256color";
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
