{ config, pkgs, ... }:

{

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "pwalsh";
  home.homeDirectory = "/Users/pwalsh";

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
    taskwarrior
    fzy
    fd
    zoxide
    cargo
    nixfmt
    rnix-lsp
    gh
    ripgrep
    direnv
    fzf
    zsh-powerlevel10k
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bat.enable = true;
  programs.broot.enable = true;
  programs.nix-index.enable = true;
  #programs.git.enable = true;
  #programs.neovim.enable = true;
  #programs.tmux.enable = true;
  #programs.zsh.enable = true;


    programs.neovim = {
      enable = true;
      vimAlias = true;
      #extraConfig = builtins.readFile ./home/extraConfig.vim;

      plugins = with pkgs.vimPlugins; [
        # Syntax / Language Support ##########################
        #vim-nix
        #vim-ruby # ruby
        #vim-go # go
        vim-toml           # toml
        # vim-gvpr           # gvpr
        rust-vim # rust
        telescope-nvim
        telescope-z-nvim
        telescope-fzy-native-nvim
        telescope-frecency-nvim
        gitsigns-nvim
        #zig-vim
        #vim-pandoc # pandoc (1/2)
        #vim-pandoc-syntax # pandoc (2/2)
        # yajs.vim           # JS syntax
        # es.next.syntax.vim # ES7 syntax

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
        #vim-commentary # gcap
        # vim-ripgrep
        #vim-indent-object # >aI
        #vim-easy-align # vipga
        vim-eunuch # :Rename foo.rb
        #vim-sneak
        #supertab
        # vim-endwise        # add end, } after opening block
        # gitv
        # tabnine-vim
        #ale # linting
        #nerdtree
        # vim-toggle-quickfix
        # neosnippet.vim
        # neosnippet-snippets
        # splitjoin.vim
        #nerdtree

        # Buffer / Pane / File Management ####################
        #fzf-vim # all the things

        # Panes / Larger features ############################
        #tagbar # <leader>5
        vim-fugitive # Gblame
      ];
    };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    #enableFzfHistory = true;
    enableSyntaxHighlighting = true;
    #enableFzfGit = true;
    #autosuggestions.enable = true;
    #autosuggestions.extraConfig.ZSH_AUTOSUGGEST_USE_ASYNC = "y";
    #histSize = 100000;
    #syntaxHighlighting.enable = true;
    #syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "root" "line" ];
    #ohMyZsh.enable = true;
    #ohMyZsh.plugins = [ "sudo" "gitfast" "vim-interaction" "docker" "taskwarrior" "tmux" "fzf" "cargo" "brew" "ripgrep" "zoxide"];
    #ohMyZsh.theme = "powerlevel10k";
  shellAliases = {
    ls="ls -G -F";
    l="exa --icons --git-ignore --git -F --extended";
    ll="exa --icons --git-ignore --git -F --extended -l";
    lt="exa --icons --git-ignore --git -F --extended -T";
    llt="exa --icons --git-ignore --git -F --extended -l -T";
    fd="fd -HI"; # when calling the command, search all
    f="\fd"; # default search this dir for files ignoring .gitignore etc
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
  extraConfig =''
    ${builtins.readFile ./home/dotfiles/tmux.conf}
  '';
};


}
