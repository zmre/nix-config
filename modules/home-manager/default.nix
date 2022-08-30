{ inputs, config, pkgs, ... }:
let
  homeDir = config.home.homeDirectory;
  defaultPkgs = with pkgs.stable; [
    # filesystem
    fd
    ripgrep
    du-dust
    fzy
    tree-sitter # need unstable to get new markdown parser
    tree-sitter-grammars.tree-sitter-markdown
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
    less
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
    mediainfo
    exif
    glow # view markdown file or dir
    mdcat # colorize markdown
    html2text

    # network
    gping
    bandwhich # bandwidth monitor by process
    # not building on m1 right now
    #bmon # bandwidth monitor by interface
    caddy # local filesystem web server
    aria # cli downloader
    ncftp
    hostname

    # misc
    neofetch # display key software/version info in term
    #nodePackages.readability-cli # quick commandline website article read
    vimv # shell script to bulk rename
    pkgs.btop
    #youtube-dl replaced by yt-dlp
    pkgs.yt-dlp
    vulnix # check for live nix apps that are listed in NVD
    tickrs # track stocks
    taskwarrior-tui
    aspell # spell checker
    kalker # cli calculator; alt. to bc and calc
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
    pkgs.babble-cli
    yubikey-manager # cli for yubikey
    # failing to build latest myself; official is 7 months behind
    # moving this to brew 2022-07-11 :-(
    #pkgs.zk-latest # cli for indexing markdown files
    pkgs.zk # cli for indexing markdown files
    pastel # cli for color manipulation
    kopia # deduping backup

    #pkgs.qutebrowser
  ];
  # below is to make compiling tools/projects without dedicated nix environments more likely to succeed
  cPkgs = with pkgs.stable; [
    automake
    autoconf
    gcc
    gnumake
    cmake
    pkg-config
    glib
    libtool
    libiconv # so many things fail to compile without this
    openssl # also needed by many things
  ];
  # sumneko-lua-language-server failing on darwin, so installing in home-linux and brew
  luaPkgs = with pkgs; [ luaformatter ];
  # using unstable in my home profile for nix commands
  nixEditorPkgs = with pkgs; [ nix statix nixfmt nixpkgs-fmt rnix-lsp ];
  # live dangerously here with unstable
  #rustPkgs = with pkgs; [ cargo cargo-watch rustfmt rust-analyzer rustc ];
  rustPkgs = with pkgs; [ cargo rustfmt rust-analyzer rustc ];
  # live dangerously here with unstable
  typescriptPkgs = with pkgs.nodePackages;
    [
      typescript
      typescript-language-server
      yarn
      diagnostic-languageserver
      eslint_d
      prettier
      vscode-langservers-extracted # lsp servers for json, html, css
      tailwindcss
      pnpm
      svelte-language-server
    ] ++ [
      # weird hack to allow for funky package name
      pkgs.nodePackages."@tailwindcss/language-server"
    ];

  networkPkgs = with pkgs.stable; [ mtr iftop ];
  guiPkgs = with pkgs;
    [
      # 22-01-29 currently fails on mac with "could not compile futures-util" :(
      #neovide
    ];

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
  home.packages = defaultPkgs ++ cPkgs ++ luaPkgs ++ nixEditorPkgs ++ rustPkgs
    ++ typescriptPkgs ++ guiPkgs ++ networkPkgs;

  # TODO: comma, gnupg?

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
    CLICOLOR = 1;
    CLICOLOR_FORCE = "yes";
    PAGER = "less";
    # Add colors to man pages
    MANPAGER = "less -R --use-color -Dd+r -Du+b +Gg -M -s";
    SYSTEMD_COLORS = "true";
    FZF_CTRL_R_OPTS = "--sort --exact";
    BROWSER = "qutebrowser";
    TERMINAL = "alacritty";
    HOMEBREW_NO_AUTO_UPDATE = 1;
    #LIBVA_DRIVER_NAME="iHD";
    ZK_NOTEBOOK_DIR = "${config.home.homeDirectory}/Notes";
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
  home.file.".config/nvim/lua/zmre/options.lua".source =
    ./dotfiles/nvim/lua/options.lua;
  home.file.".config/nvim/lua/zmre/abbreviations.lua".source =
    ./dotfiles/nvim/lua/abbreviations.lua;
  home.file.".config/nvim/lua/zmre/filetypes.lua".source =
    ./dotfiles/nvim/lua/filetypes.lua;
  home.file.".config/nvim/lua/zmre/mappings.lua".source =
    ./dotfiles/nvim/lua/mappings.lua;
  home.file.".config/nvim/lua/zmre/tools.lua".source =
    ./dotfiles/nvim/lua/tools.lua;
  home.file.".config/nvim/lua/zmre/plugins.lua".source =
    ./dotfiles/nvim/lua/plugins.lua;
  home.file.".config/nvim/lua/zmre/vscode.lua".source =
    ./dotfiles/nvim/lua/vscode.lua;
  home.file.".config/nvim/vim/colors.vim".source =
    ./dotfiles/nvim/vim/colors.vim;
  home.file.".wallpaper.jpg".source = ./wallpaper/castle2.jpg;
  home.file.".lockpaper.png".source = ./wallpaper/kali.png;
  #home.file.".tmux.conf".source =
  #"${config.home-manager-files}/.config/tmux/tmux.conf";
  #home.file.".gitignore".source =
  #"${config.home-manager-files}/.config/git/ignore";
  # Config for hackernews-tui to make it darker
  home.file.".config/hn-tui.toml".text = ''
    [theme.palette]
    background = "#242424"
    foreground = "#f6f6ef"
    selection_background = "#4a4c4c"
    selection_foreground = "#d8dad6"
  '';

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      italic-text = "always";
      style =
        "plain"; # no line numbers, git status, etc... more like cat with colors
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
    enable = true;
    colorTheme = "dark-256";
    dataLocation = "~/.task";
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
    # solely needed for taskwiki/vim-roam-task
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [ pynvim tasklib six ]);
    extraPackages = with pkgs; [
      vale # style checker for writing
      proselint # style checker for writing
      #zk # note finder -- moved this to global location
    ];
    # make sure impatient is loaded before everything else to speed things up
    extraConfig = ''
      lua << EOF
          require('impatient')
          require('impatient').enable_profile()
          require('zmre.options').defaults()
          require('zmre.options').gui()
          require('zmre.mappings')
          require('zmre.abbreviations')
          if vim.g.vscode ~= nil then
            require('zmre.vscode')
          else
            require('zmre.filetypes').config()
            require('zmre.plugins').ui()
            require('zmre.plugins').diagnostics()
            require('zmre.plugins').telescope()
            require('zmre.plugins').completions()
            require('zmre.plugins').notes()
            require('zmre.plugins').misc()
          end
      EOF
    '';

    # going unstable here; living dangerously
    plugins = with pkgs.vimPlugins; [
      # Common dependencies of other plugins
      popup-nvim # dependency of some other plugins
      plenary-nvim # Library for lua plugins; used by many plugins here

      # Syntax / Language Support ##########################
      vim-polyglot # lazy load all the syntax plugins for all the languages
      rust-tools-nvim # lsp stuff and more for rust
      crates-nvim # inline intelligence for Cargo.toml
      nvim-lspconfig # setup LSP for intelligent coding
      # nvim-lsp-ts-utils for inlays
      null-ls-nvim # formatting and linting via lsp system
      trouble-nvim # navigate all warnings and errors in quickfix-like window
      lspsaga-nvim
      todo-comments-nvim
      #copilot-vim # github copilot

      # UI #################################################
      onedarkpro-nvim # colorscheme
      #onedark-vim # colorscheme
      zephyr-nvim # alternate colorscheme
      telescope-nvim # da best popup fuzzy finder
      telescope-fzy-native-nvim # but fzy gives better results
      telescope-frecency-nvim # and frecency comes in handy too
      telescope-media-files # only works on linux, but image preview
      dressing-nvim # dresses up vim.ui.input and vim.ui.select and uses telescope
      nvim-colorizer-lua # color over CSS like #00ff00
      nvim-web-devicons # makes things pretty; used by many plugins below
      nvim-tree-lua # file navigator
      gitsigns-nvim # git status in gutter
      symbols-outline-nvim # navigate the current file better
      lualine-nvim # nice status bar at bottom
      #barbar-nvim # nice buffers (tabs) bar at top
      vim-bbye # fix bdelete buffer stuff needed with bufferline
      bufferline-nvim
      indent-blankline-nvim # visual indent
      toggleterm-nvim # better terminal management
      nvim-treesitter # better code coloring
      playground # treesitter playground
      nvim-treesitter-textobjects
      nvim-treesitter-context # keep current block header (func defn or whatever) on first line

      # Editor Features ####################################
      vim-abolish # better abbreviations / spelling fixer
      #vim-surround # most important plugin for quickly handling brackets
      surround-nvim # .... updated lua-based alternative to tpope's surround
      vim-unimpaired # bunch of convenient navigation key mappings
      vim-repeat # supports all of the above so you can use .
      vim-rsi # brings keyline bindings to editing (like ctrl-e for end of line when in insert mode)
      vim-visualstar # press * or # on a word to find it
      kommentary # code commenter
      nvim-ts-context-commentstring # makes kommentary contextual for embedded languages
      vim-eunuch # brings cp/mv type commands. :Rename and :Move are particularly handy

      # Autocompletion
      nvim-cmp # generic autocompleter
      cmp-nvim-lsp # use lsp as source for completions
      cmp-nvim-lua # makes vim config editing better with completions
      cmp-buffer # any text in open buffers
      cmp-path # complete paths
      cmp-cmdline # completing in :commands
      cmp-emoji # complete :emojis:
      nvim-autopairs # balances parens as you type
      vim-emoji # TODO: redundant now?
      luasnip # snippets driver
      cmp_luasnip # snippets completion
      friendly-snippets # actual library of snippets used by luasnip

      # Notes
      vim-roam-task # a clone of taskwiki that doesn't require vimwiki
      zk-nvim # lsp for a folder of notes for searching/linking/etc.
      goyo-vim # distraction free, width constrained writing mode
      limelight-vim # pairs with goyo for typewriter mode dimming inactive paragraphs
      {
        plugin = vim-grammarous; # grammar check
        optional = true; # don't want it to load unless it's needed
      }

      # Misc
      vim-fugitive # git management
      project-nvim
      vim-tmux-navigator # navigate vim and tmux panes together
      FixCursorHold-nvim # remove this when neovim #12587 is resolved
      impatient-nvim # speeds startup times by caching lua bytecode
      which-key-nvim
      direnv-vim # auto-execute nix direnv setups
      #nvim-whichkey-setup-lua
    ];
  };
  home.file."${config.xdg.configHome}/nvim/parser/tsx.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-tsx}/parser";
  # TODO: uncomment this when treesitter nix highlighting isn't so busted 2022-05-17, 2022-08-02
  #home.file."${config.xdg.configHome}/nvim/parser/nix.so".source =
  #"${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
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
  home.file."${config.xdg.configHome}/nvim/parser/markdown.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-markdown}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/svelte.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-svelte}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/regex.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-regex}/parser";
  # Prose linting
  home.file.".vale.ini".text = ''
    StylesPath = .styles

    MinAlertLevel = suggestion
    Vocab = Base

    Packages = Google, proselint

    [*]
    BasedOnStyles = Vale, Google, proselint
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
      github.copilot
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
      asvetliakov.vscode-neovim
      brettm12345.nixfmt-vscode
      davidanson.vscode-markdownlint
      pkief.material-icon-theme
      dracula-theme.theme-dracula
      eamodio.gitlens # for git blame
      marp-team.marp-vscode # for markdown slides
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
      {
        "key" = "r";
        "command" = "renameFile";
        "when" =
          "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
      }
      {
        "key" = "enter";
        "command" = "-renameFile";
        "when" =
          "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
      }
      {
        "key" = "j";
        "command" = "list.focusDown";
        "when" =
          "listFocus && explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
      }
      {
        "key" = "k";
        "command" = "list.focusUp";
        "when" =
          "listFocus && explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
      }
      {
        "key" = "ctrl+j";
        "command" = "selectNextSuggestion";
        "when" =
          "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
      }
      {
        "key" = "ctrl+k";
        "command" = "selectPrevSuggestion";
        "when" =
          "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
      }
      {
        "key" = "ctrl+j";
        "command" = "workbench.action.quickOpenNavigateNext";
        "when" = "inQuickOpen";
      }
      {
        "key" = "tab";
        "command" = "selectNextSuggestion";
        "when" =
          "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
      }
      {
        "key" = "tab";
        "command" = "workbench.action.quickOpenNavigateNext";
        "when" = "inQuickOpen";
      }
      {
        "key" = "shit+tab";
        "command" = "selectPrevSuggestion";
        "when" =
          "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
      }
      {
        "key" = "shift+tab";
        "command" = "selectPrevSuggestion";
        "when" =
          "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
      }
      {
        "key" = "shift+tab";
        "command" = "workbench.action.quickOpenNavigatePrevious";
        "when" = "inQuickOpen";
      }
      {
        "key" = "ctrl+k";
        "command" = "workbench.action.quickOpenNavigatePrevious";
        "when" = "inQuickOpen";
      }
      {
        "key" = "enter";
        "command" = "list.select";
        "when" = "explorerViewletVisible && filesExplorerFocus";
      }
      {
        "key" = "l";
        "command" = "list.select";
        "when" = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
      }
      {
        "key" = "o";
        "command" = "list.toggleExpand";
        "when" = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
      }
      {
        "key" = "h";
        "command" = "list.collapse";
        "when" = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
      }
      {
        "key" = "a";
        "command" = "explorer.newFile";
        "when" = "filesExplorerFocus && !inputFocus";
      }
      {
        "key" = "shift+a";
        "command" = "explorer.newFolder";
        "when" = "filesExplorerFocus && !inputFocus";
      }
      {
        "key" = "shift+;";
        "command" = "insertPrevSuggestion";
        "when" =
          "hasOtherSuggestions && textInputFocus && textInputFocus && !inSnippetMode && !suggestWidgetVisible && config.editor.tabCompletion == 'on'";
      }
      {
        "key" = "ctrl+l";
        "when" = "sideBarFocus";
        "command" = "workbench.action.focusActiveEditorGroup";
      }
      {
        "key" = "ctrl+k";
        "command" = "workbench.action.focusActiveEditorGroup";
        "when" = "terminalFocus";
      }
      {
        "key" = "ctrl+shift+t";
        "command" = "workbench.action.terminal.focus";
        "when" = "!terminalFocus";
      }
      {
        "key" = "ctrl+j";
        "command" = "-editor.action.insertLineAfter";
        "when" =
          "editorTextFocus && neovim.ctrlKeysInsert && !neovim.recording && neovim.mode == 'insert'";
      }
      {
        "key" = "alt+j";
        "command" = "workbench.action.terminal.focus";
        "when" = "!terminalFocus";
      }
      {
        "key" = "ctrl+shift+t";
        "command" = "workbench.action.togglePanel";
      }
      {
        "key" = "ctrl+j";
        "command" = "-workbench.action.togglePanel";
      }
      {
        "key" = "shift+k";
        "command" = "editor.action.showHover";
        "when" = "editorTextFocus";
      }
      {
        "key" = "ctrl+k ctrl+i";
        "command" = "-editor.action.showHover";
        "when" = "editorTextFocus";
      }
      {
        "key" = "shift+tab";
        "command" = "-acceptAlternativeSelectedSuggestion";
        "when" = "suggestWidgetVisible && textInputFocus";
      }
      {
        "key" = "ctrl+f";
        "command" = "-vscode-neovim.ctrl-f";
        "when" =
          "editorTextFocus && neovim.ctrlKeysNormal && neovim.init && neovim.mode != 'insert'";
      }
    ];
    userSettings = {
      # Much of the following adapted from https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/settings.json
      "editor.tabSize" = 2;
      "editor.fontLigatures" = true;
      "editor.guides.indentation" = false;
      "editor.insertSpaces" = true;
      "editor.fontFamily" =
        "'Hasklug Nerd Font', 'JetBrainsMono Nerd Font', 'FiraCode Nerd Font','SF Mono', Menlo, Monaco, 'Courier New', monospace";
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
      "vsintellicode.modify.editor.suggestSelection" =
        "automaticallyOverrodeDefaultValue";
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
      "vscode-neovim.neovimInitVimPaths.darwin" = "$HOME/.config/nvim/init.vim";
      "vscode-neovim.neovimInitVimPaths.linux" = "$HOME/.config/nvim/init.vim";
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
            "settings" = { "fontStyle" = "bold"; };
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
            "settings" = { "fontStyle" = "italic"; };
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
            "settings" = { "fontStyle" = ""; };
          }
          {
            "name" = "One Dark bold italic";
            "scope" = [ "keyword.other.important" ];
            "settings" = { "fontStyle" = "bold italic"; };
          }
        ];
      };

      "whichkey.sortOrder" = "alphabetically";
      "whichkey.bindings" = [
        {
          "key" = ";";
          "name" = "commands";
          "type" = "command";
          "command" = "workbench.action.showCommands";
        }
        {
          "key" = "/";
          "name" = "comment";
          "type" = "command";
          "command" = "vscode-neovim.send";
          "args" = "<C-/>";
        }
        {
          "key" = "b";
          "name" = "Buffers/Editors...";
          "type" = "bindings";
          "bindings" = [
            {
              "key" = "b";
              "name" = "Show all buffers/editors";
              "type" = "command";
              "command" = "workbench.action.showAllEditors";
            }
            {
              "key" = "d";
              "name" = "Close active editor";
              "type" = "command";
              "command" = "workbench.action.closeActiveEditor";
            }
            {
              "key" = "h";
              "name" = "Move editor into left group";
              "type" = "command";
              "command" = "workbench.action.moveEditorToLeftGroup";
            }
            {
              "key" = "j";
              "name" = "Move editor into below group";
              "type" = "command";
              "command" = "workbench.action.moveEditorToBelowGroup";
            }
            {
              "key" = "k";
              "name" = "Move editor into above group";
              "type" = "command";
              "command" = "workbench.action.moveEditorToAboveGroup";
            }
            {
              "key" = "l";
              "name" = "Move editor into right group";
              "type" = "command";
              "command" = "workbench.action.moveEditorToRightGroup";
            }
            {
              "key" = "m";
              "name" = "Close other editors";
              "type" = "command";
              "command" = "workbench.action.closeOtherEditors";
            }
            {
              "key" = "n";
              "name" = "Next editor";
              "type" = "command";
              "command" = "workbench.action.nextEditor";
            }
            {
              "key" = "p";
              "name" = "Previous editor";
              "type" = "command";
              "command" = "workbench.action.previousEditor";
            }
            {
              "key" = "N";
              "name" = "New untitled editor";
              "type" = "command";
              "command" = "workbench.action.files.newUntitledFile";
            }
            {
              "key" = "u";
              "name" = "Reopen closed editor";
              "type" = "command";
              "command" = "workbench.action.reopenClosedEditor";
            }
            {
              "key" = "y";
              "name" = "Copy buffer to clipboard";
              "type" = "commands";
              "commands" = [
                "editor.action.selectAll"
                "editor.action.clipboardCopyAction"
                "cancelSelection"
              ];
            }
          ];
        }
        {
          "key" = "d";
          "name" = "Debug...";
          "type" = "bindings";
          "bindings" = [
            {
              "key" = "d";
              "name" = "Start debug";
              "type" = "command";
              "command" = "workbench.action.debug.start";
            }
            {
              "key" = "S";
              "name" = "Stop debug";
              "type" = "command";
              "command" = "workbench.action.debug.stop";
            }
            {
              "key" = "c";
              "name" = "Continue debug";
              "type" = "command";
              "command" = "workbench.action.debug.continue";
            }
            {
              "key" = "p";
              "name" = "Pause debug";
              "type" = "command";
              "command" = "workbench.action.debug.pause";
            }
            {
              "key" = "r";
              "name" = "Run without debugging";
              "type" = "command";
              "command" = "workbench.action.debug.run";
            }
            {
              "key" = "R";
              "name" = "Restart debug";
              "type" = "command";
              "command" = "workbench.action.debug.restart";
            }
            {
              "key" = "i";
              "name" = "Step into";
              "type" = "command";
              "command" = "workbench.action.debug.stepInto";
            }
            {
              "key" = "s";
              "name" = "Step over";
              "type" = "command";
              "command" = "workbench.action.debug.stepOver";
            }
            {
              "key" = "o";
              "name" = "Step out";
              "type" = "command";
              "command" = "workbench.action.debug.stepOut";
            }
            {
              "key" = "b";
              "name" = "Toggle breakpoint";
              "type" = "command";
              "command" = "editor.debug.action.toggleBreakpoint";
            }
            {
              "key" = "B";
              "name" = "Toggle inline breakpoint";
              "type" = "command";
              "command" = "editor.debug.action.toggleInlineBreakpoint";
            }
            {
              "key" = "j";
              "name" = "Jump to cursor";
              "type" = "command";
              "command" = "debug.jumpToCursor";
            }
            {
              "key" = "v";
              "name" = "REPL";
              "type" = "command";
              "command" = "workbench.debug.action.toggleRepl";
            }
            {
              "key" = "w";
              "name" = "Focus on watch window";
              "type" = "command";
              "command" = "workbench.debug.action.focusWatchView";
            }
            {
              "key" = "W";
              "name" = "Add to watch";
              "type" = "command";
              "command" = "editor.debug.action.selectionToWatch";
            }
          ];
        }
        {
          "key" = "e";
          "name" = "Toggle Explorer";
          "type" = "command";
          "command" = "workbench.action.toggleSidebarVisibility";
        }
        {
          "key" = "f";
          "name" = "Find & Replace...";
          "type" = "bindings";
          "bindings" = [
            {
              "key" = "f";
              "name" = "File";
              "type" = "command";
              "command" = "editor.action.startFindReplaceAction";
            }
            {
              "key" = "s";
              "name" = "Symbol";
              "type" = "command";
              "command" = "editor.action.rename";
              "when" =
                "editorHasRenameProvider && editorTextFocus && !editorReadonly";
            }
            {
              "key" = "p";
              "name" = "Project";
              "type" = "command";
              "command" = "workbench.action.replaceInFiles";
            }
          ];
        }
        {
          "key" = "g";
          "name" = "Git...";
          "type" = "bindings";
          "bindings" = [
            {
              "key" = "b";
              "name" = "Checkout";
              "type" = "command";
              "command" = "git.checkout";
            }
            {
              "key" = "c";
              "name" = "Commit";
              "type" = "command";
              "command" = "git.commit";
            }
            {
              "key" = "d";
              "name" = "Delete Branch";
              "type" = "command";
              "command" = "git.deleteBranch";
            }
            {
              "key" = "f";
              "name" = "Fetch";
              "type" = "command";
              "command" = "git.fetch";
            }
            {
              "key" = "i";
              "name" = "Init";
              "type" = "command";
              "command" = "git.init";
            }
            {
              "key" = "m";
              "name" = "Merge";
              "type" = "command";
              "command" = "git.merge";
            }
            {
              "key" = "p";
              "name" = "Publish";
              "type" = "command";
              "command" = "git.publish";
            }
            {
              "key" = "s";
              "name" = "Stash";
              "type" = "command";
              "command" = "workbench.view.scm";
            }
            {
              "key" = "S";
              "name" = "Stage";
              "type" = "command";
              "command" = "git.stage";
            }
            {
              "key" = "U";
              "name" = "Unstage";
              "type" = "command";
              "command" = "git.unstage";
            }
          ];
        }
        {
          "key" = "h";
          "name" = "Split Horizontal";
          "type" = "command";
          "command" = "workbench.action.splitEditorDown";
        }
        {
          "key" = "i";
          "name" = "Insert...";
          "type" = "bindings";
          "bindings" = [
            {
              "key" = "j";
              "name" = "Insert line below";
              "type" = "command";
              "command" = "editor.action.insertLineAfter";
            }
            {
              "key" = "k";
              "name" = "Insert line above";
              "type" = "command";
              "command" = "editor.action.insertLineBefore";
            }
            {
              "key" = "s";
              "name" = "Insert snippet";
              "type" = "command";
              "command" = "editor.action.insertSnippet";
            }
          ];
        }
        {
          "key" = "m";
          "name" = "minimap";
          "type" = "command";
          "command" = "editor.action.toggleMinimap";
        }
        {
          "key" = "n";
          "name" = "highlight";
          "type" = "command";
          "command" = "vscode-neovim.send";
          "args" = ":noh<CR>";
        }
        {
          "key" = "s";
          "name" = "Search...";
          "type" = "bindings";
          "bindings" = [
            {
              "key" = "f";
              "name" = "files";
              "type" = "command";
              "command" = "workbench.action.quickOpen";
            }
            {
              "key" = "t";
              "name" = "text";
              "type" = "command";
              "command" = "workbench.action.findInFiles";
            }
          ];
        }
        {
          "key" = "S";
          "name" = "Show...";
          "type" = "bindings";
          "bindings" = [
            {
              "key" = "e";
              "name" = "Show explorer";
              "type" = "command";
              "command" = "workbench.view.explorer";
            }
            {
              "key" = "s";
              "name" = "Show search";
              "type" = "command";
              "command" = "workbench.view.search";
            }
            {
              "key" = "g";
              "name" = "Show source control";
              "type" = "command";
              "command" = "workbench.view.scm";
            }
            {
              "key" = "t";
              "name" = "Show test";
              "type" = "command";
              "command" = "workbench.view.extension.test";
            }
            {
              "key" = "r";
              "name" = "Show remote explorer";
              "type" = "command";
              "command" = "workbench.view.remote";
            }
            {
              "key" = "x";
              "name" = "Show extensions";
              "type" = "command";
              "command" = "workbench.view.extensions";
            }
            {
              "key" = "p";
              "name" = "Show problem";
              "type" = "command";
              "command" = "workbench.actions.view.problems";
            }
            {
              "key" = "o";
              "name" = "Show output";
              "type" = "command";
              "command" = "workbench.action.output.toggleOutput";
            }
            {
              "key" = "d";
              "name" = "Show debug console";
              "type" = "command";
              "command" = "workbench.debug.action.toggleRepl";
            }
          ];
        }
        {
          "key" = "t";
          "name" = "Terminal...";
          "type" = "bindings";
          "bindings" = [{
            "key" = "t";
            "name" = "Toggle Terminal";
            "type" = "command";
            "command" = "workbench.action.togglePanel";
          }];
        }
        {
          "key" = "T";
          "name" = "UI toggles...";
          "type" = "bindings";
          "bindings" = [
            {
              "key" = "b";
              "name" = "Toggle side bar visibility";
              "type" = "command";
              "command" = "workbench.action.toggleSidebarVisibility";
            }
            {
              "key" = "j";
              "name" = "Toggle panel visibility";
              "type" = "command";
              "command" = "workbench.action.togglePanel";
            }
            {
              "key" = "F";
              "name" = "Toggle full screen";
              "type" = "command";
              "command" = "workbench.action.toggleFullScreen";
            }
            {
              "key" = "s";
              "name" = "Select theme";
              "type" = "command";
              "command" = "workbench.action.selectTheme";
            }
            {
              "key" = "m";
              "name" = "Toggle maximized panel";
              "type" = "command";
              "command" = "workbench.action.toggleMaximizedPanel";
            }
            {
              "key" = "t";
              "name" = "Toggle tool/activity bar visibility";
              "type" = "command";
              "command" = "workbench.action.toggleActivityBarVisibility";
            }
            {
              "key" = "T";
              "name" = "Toggle tab visibility";
              "type" = "command";
              "command" = "workbench.action.toggleTabsVisibility";
            }
          ];
        }
        {
          "key" = "v";
          "name" = "Split Vertical";
          "type" = "command";
          "command" = "workbench.action.splitEditor";
        }
        {
          "key" = "w";
          "name" = "Window...";
          "type" = "bindings";
          "bindings" = [
            {
              "key" = "W";
              "name" = "Focus previous editor group";
              "type" = "command";
              "command" = "workbench.action.focusPreviousGroup";
            }
            {
              "key" = "h";
              "name" = "Move editor group left";
              "type" = "command";
              "command" = "workbench.action.moveActiveEditorGroupLeft";
            }
            {
              "key" = "j";
              "name" = "Move editor group down";
              "type" = "command";
              "command" = "workbench.action.moveActiveEditorGroupDown";
            }
            {
              "key" = "k";
              "name" = "Move editor group up";
              "type" = "command";
              "command" = "workbench.action.moveActiveEditorGroupUp";
            }
            {
              "key" = "l";
              "name" = "Move editor group right";
              "type" = "command";
              "command" = "workbench.action.moveActiveEditorGroupRight";
            }
            {
              "key" = "t";
              "name" = "Toggle editor group sizes";
              "type" = "command";
              "command" = "workbench.action.toggleEditorWidths";
            }
            {
              "key" = "m";
              "name" = "Maximize editor group";
              "type" = "command";
              "command" = "workbench.action.minimizeOtherEditors";
            }
            {
              "key" = "M";
              "name" = "Maximize editor group and hide side bar";
              "type" = "command";
              "command" = "workbench.action.maximizeEditor";
            }
            {
              "key" = "=";
              "name" = "Reset editor group sizes";
              "type" = "command";
              "command" = "workbench.action.evenEditorWidths";
            }
            {
              "key" = "z";
              "name" = "Combine all editors";
              "type" = "command";
              "command" = "workbench.action.joinAllGroups";
            }
            {
              "key" = "d";
              "name" = "Close editor group";
              "type" = "command";
              "command" = "workbench.action.closeEditorsInGroup";
            }
            {
              "key" = "x";
              "name" = "Close all editor groups";
              "type" = "command";
              "command" = "workbench.action.closeAllGroups";
            }
          ];
        }
        {
          "key" = "z";
          "name" = "Toggle zen mode";
          "type" = "command";
          "command" = "workbench.action.toggleZenMode";
        }
      ];
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };
  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    includes = [ "*.conf" ];
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
  programs.gh = {
    enable = true;
    # stable is currently failing as of 2022-02-17
    # error: Could not find a version that satisfies the requirement tomlkit<0.8,>=0.7 (from remarshal)
    package = pkgs.gh;
    settings = { git_protocol = "ssh"; };
  };
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [ thumbnail sponsorblock ];
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
      autofit-larger =
        "100%x95%"; # resize window in case it's larger than W%xH% of the screen
      input-media-keys = "yes"; # enable/disable OSX media keys
      hls-bitrate = "max"; # use max quality for HLS streams

      user-agent =
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:57.0) Gecko/20100101 Firefox/58.0";
    };
    defaultProfiles = [ "gpu-hq" ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    # let's the terminal track current working dir but only builds on linux
    enableVteIntegration = if pkgs.stdenvNoCC.isDarwin then false else true;

    history = {
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      save = 10000; # save 10,000 lines of history
    };
    initExtraBeforeCompInit = ''
      source ${inputs.gitstatus.outPath}/gitstatus.plugin.zsh
      source ${inputs.powerlevel10k.outPath}/powerlevel10k.zsh-theme
    '';
    completionInit = ''
      autoload -U compinit
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

      # Setup zoxide
      eval "$(zoxide init zsh)"

      # Prompt stuff
      source ${./dotfiles/p10k.zsh}
    '';
    sessionVariables = { };
    plugins = [
      {
        name = "powerlevel10k";
        src = inputs.powerlevel10k;
      }
      {
        name = "powerlevel10k-config";
        src = ./dotfiles/p10k.zsh;
        file = "p10k.zsh";
      }
      {
        # lets me use zsh as the shell in a nix-shell environment
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.4.0";
          sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
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
    shellAliases = {
      ls = "ls --color=auto -F";
      l = "exa --icons --git-ignore --git -F --extended";
      ll = "exa --icons --git-ignore --git -F --extended -l";
      lt = "exa --icons --git-ignore --git -F --extended -T";
      llt = "exa --icons --git-ignore --git -F --extended -l -T";
      fd = "\\fd -H -t d"; # default search directories
      f = "\\fd -H"; # default search this dir for files ignoring .gitignore etc
      lf = "~/.config/lf/lfimg";
      nixosedit =
        "nvim $(realpath /etc/nixos/configuration.nix) ; sudo nixos-rebuild switch --flake ~/.config/nixpkgs/.#";
      nixedit =
        "nvim ~/.config/nixpkgs/home.nix ; sudo nixos-rebuild switch --flake ~/.config/nixpkgs/.#";
      qp = ''
        qutebrowser --temp-basedir --set content.private_browsing true --set colors.tabs.bar.bg "#552222" --config-py "$HOME/.config/qutebrowser/config.py" --qt-arg name "qp,qp"'';
      calc = "kalker";
      df = "duf";
      # search for a note and with ctrl-n, create it if not found
      # add subdir as needed like "n meetings" or "n wiki"
      n = "zk edit --interactive";
      hmswitch = ''
        nix-shell -p home-manager --run "home-manager switch --flake ~/.config/nixpkgs/.#$(hostname -s)"'';
      dwupdate =
        "pushd ~/.config/nixpkgs ; nix flake update ; /opt/homebrew/bin/brew update; popd ; pushd ~; darwin-rebuild switch --flake ~/.config/nixpkgs/.#$(hostname -s) --show-trace; popd";
      dwswitch =
        "pushd ~; darwin-rebuild switch --flake ~/.config/nixpkgs/.#$(hostname -s) --show-trace; popd";
      noswitch =
        "pushd ~; sudo nixos-rebuild switch --flake ~/.config/nixpkgs/.# --show-trace; popd";
    };
  };

  programs.exa.enable = true;
  # my prefered file explorer; mnemonic: list files
  programs.lf = {
    enable = true;
    settings = {
      icons = true;
      incsearch = true;
      ifs = "\n";
      findlen = 2;
      scrolloff = 3;
      drawbox = true;
      promptfmt =
        "\\033[1;38;5;51m[\\033[38;5;39m%u\\033[38;5;51m@\\033[38;5;39m%h\\033[38;5;51m] \\033[0;38;5;49m%w/\\033[38;5;48m%f\\033[0m";
    };
    extraConfig = ''
      set incfilter
      set mouse
      set truncatechar ⋯
      set cleaner ~/.config/lf/cls.sh
      set previewer ~/.config/lf/pv.sh
    '';
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
      i = "!~/.config/lf/pager.sh $f"; # mnemonic: info
      # use the system open command
      o = "open";
      "<c-z>" = "$ kill -STOP $PPID";
      "gr" = "fzf_search"; # ripgrep search
      "gd" = "fd_dir"; # mnemonic: go find dir
      "gf" = "f_file"; # mnemonic: go find file
      "gz" = "push :z<space>"; # mnemonic: go zoxide
      "R" = "vi-rename";
      "<enter>" = ":printfx; quit";
    };
    #set previewer ~/.config/lf/previewer.sh

  };
  home.file.".config/lf/lfimg".source = ./dotfiles/lf/lfimg;
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
      init.defaultBranch = "main";
      http.sslVerify = true;
      commit.verbose = true;
      credential.helper = if pkgs.stdenvNoCC.isDarwin then
        "osxkeychain"
      else
        "cache --timeout=10000000";
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
    browser = if pkgs.stdenvNoCC.isDarwin then
      "open"
    else
      "${pkgs.xdg-utils}/bin/xdg-open";
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
        tags = [ "security" ];
        title = "Cyberscoop";
        url = "https://www.cyberscoop.com/feed/";
      }
      {
        tags = [ "security" ];
        title = "Krebs on Security";
        url = "https://krebsonsecurity.com/feed/";
      }
      {
        tags = [ "security" ];
        title = "DefenseOne";
        url = "http://www.defenseone.com/rss/technology/ ";
      }
      {
        tags = [ "news" ];
        title = "NPR";
        url = "http://www.npr.org/rss/rss.php?id=1001";
      }
      {
        tags = [ "news" ];
        title = "Reuters Domestic";
        url = "http://feeds.reuters.com/Reuters/domesticNews";
      }
      {
        tags = [ "startup" ];
        title = "TechCrunch";
        url = "https://techcrunch.com/feed/";
      }
      {
        tags = [ "tech" ];
        title = "Reuters Tech";
        url = "http://feeds.reuters.com/reuters/technologyNews?format=xml";
      }
      {
        tags = [ "tech" ];
        title = "EFF";
        url = "http://www.eff.org/rss/updates.xml";
      }
    ];
  };

  programs.alacritty = {
    enable = true;
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
      font.size = if pkgs.stdenvNoCC.isDarwin then 16 else 9;
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
