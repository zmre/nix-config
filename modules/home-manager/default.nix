{ inputs, config, pkgs, ... }:
let
  homeDir = config.home.homeDirectory;

  defaultPkgs = with pkgs.stable; [
    # filesystem
    fd
    ripgrep
    fzy
    curl
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
    exif

    # network
    hostname

    # misc
    vulnix # check for live nix apps that are listed in NVD
    nix-tree # explore dependencies
    pstree
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
  # using unstable in my home profile for nix commands
  nixEditorPkgs = with pkgs; [ nix statix nixfmt pkgs.fmt rnix-lsp ];
  # live dangerously here with unstable
  rustPkgs = with pkgs; [ cargo rustfmt rust-analyzer rustc ];
  # live dangerously here with unstable
  typescriptPkgs = with pkgs.stable.nodePackages;
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
      pkgs.stable.nodePackages."@tailwindcss/language-server"
    ];

  networkPkgs = with pkgs.stable; [ mtr iftop ];

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
  home.packages = defaultPkgs ++ cPkgs ++ nixEditorPkgs ++ rustPkgs
    ++ typescriptPkgs ++ networkPkgs;

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    TERM = "xterm-256color";
    KEYTIMEOUT = 1;
    #EDITOR = "nvim";
    #VISUAL = "nvim";
    #GIT_EDITOR = "nvim";
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
    HOMEBREW_NO_AUTO_UPDATE = 1;
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

  # I really don't use VSCode. I try it now and then to see what I think.
  # My setup uses Neovim in the background whenever you go to Normal mode.
  # But it is a little bit buggy and though it's slightly prettier, not
  # currently worth it. I'm still keeping it in because of pair programming
  # stuff for that rare occasion.
  programs.vscode = {
    enable = true;
    mutableExtensionsDir =
      true; # to allow vscode to install extensions not available via nix
    # package = pkgs.unstable.vscode-fhs; # or pkgs.vscodium or pkgs.vscode-with-extensions
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
    };
  };

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
    includes = [ "*.conf" ];
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    # let's the terminal track current working dir but only builds on linux
    enableVteIntegration =
      if pkgs.stable.stdenvNoCC.isDarwin then false else true;

    history = {
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      save = 10000; # save 10,000 lines of history
    };
    completionInit = ''
      autoload -U compinit
    '';
    initExtra = ''
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
      bindkey '^r' history-incremental-search-backward
      bindkey '^s' history-incremental-search-forward

      # You might not like what I'm doing here, but '/' works like ctrl-r
      # and matches as you type. I've added pattern matches here though.

      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd 'v' edit-command-line

      setopt list_ambiguous

      zmodload -a autocomplete
      zmodload -a complist
    '';
    sessionVariables = { };
    shellAliases = {
      ls = "ls --color=auto -F";
      l = "exa --icons --git-ignore --git -F --extended";
      ll = "exa --icons --git-ignore --git -F --extended -l";
      lt = "exa --icons --git-ignore --git -F --extended -T";
      llt = "exa --icons --git-ignore --git -F --extended -l -T";
      dwupdate =
        "pushd ~/.config/nixpkgs ; nix flake update ; /opt/homebrew/bin/brew update; popd ; pushd ~; darwin-rebuild switch --flake ~/.config/nixpkgs/.#$(hostname -s) --show-trace; /opt/homebrew/bin/brew upgrade ; /opt/homebrew/bin/brew upgrade --cask; popd";
      dwswitch =
        "pushd ~; darwin-rebuild switch --flake ~/.config/nixpkgs/.#$(hostname -s) --show-trace; popd";
    };
  };

  programs.exa.enable = true;

  programs.git = {
    enable = true;
    userName = "Colt Frederickson";
    userEmail = "colt.frederickson@ironcorelabs.com";
    aliases = {
      gone = ''
        ! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == "[gone]" {print $1}' | xargs -r git branch -D'';
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
      github.user = "coltfred";
      color.ui = true;
      pull.rebase = true;
      merge.conflictstyle = "diff3";
      init.defaultBranch = "main";
      http.sslVerify = true;
      commit.verbose = true;
      credential.helper = if pkgs.unstable.stdenvNoCC.isDarwin then
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

}
