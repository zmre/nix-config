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
    fzf
    fzy
    gh
    git
    nixfmt
    rnix-lsp
    ripgrep
    taskwarrior
    zoxide
    zsh-powerlevel10k
  ];

  home.file.".p10k.zsh".source = ./home/dotfiles/p10k.zsh;
  home.file.".config/nvim/lua/options.lua".source = ./home/dotfiles/nvim/lua/options.lua;
  home.file.".config/nvim/lua/abbreviations.lua".source = ./home/dotfiles/nvim/lua/abbreviations.lua;
  home.file.".config/nvim/lua/filetypes.lua".source = ./home/dotfiles/nvim/lua/filetypes.lua;
  home.file.".config/nvim/lua/mappings.lua".source = ./home/dotfiles/nvim/lua/mappings.lua;
  home.file.".config/nvim/lua/tools.lua".source = ./home/dotfiles/nvim/lua/tools.lua;
  home.file.".config/nvim/vim/colors.vim".source = ./home/dotfiles/nvim/vim/colors.vim;

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
    oh-my-zsh.theme = "../../../../../../../../$HOME/.nix-profile/share/zsh-powerlevel10k/powerlevel10k";
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
  };

  programs.tmux = {
    enable = true;
    #enableSensible = true;
    #enableMouse = true;
    #enableFzf = true;
    #enableVim = true;
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
