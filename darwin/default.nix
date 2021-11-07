{ config, pkgs, ... }:

let
  callPackage = pkgs.callPackage;

in {
  # imports = [ ./nix-darwin-home-manager.nix ./home.nix ];
  # home-manager.useUserPackages = true;

  nixpkgs.config.allowUnfree = true;

  home.username = "pwalsh";
  home.homeDirectory = "/Users/pwalsh";
  users.users.pwalsh = {
    home = "/Users/pwalsh";
    description = "Patrick Walsh";
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    config.services.chunkwm.package
    curl
    less
    shellcheck
    darwin-zsh-completions
  ];
  users.defaultUserShell = "${pkgs.zsh}/bin/zsh";
  environment.shells = [ pkgs.zsh ];
  environment.variables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    TERM = "xterm-256color";
    EDITOR = "nvim";
    VISUAL = EDITOR;
    GIT_EDITOR = EDITOR;
    LS_COLORS="no=00:fi=00:di=01;34:ln=35;40:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:";
    LSCOLORS="ExfxcxdxCxegedabagacad";
    FIGNORE="*.o:~:Application Scripts:CVS:.git";
    TZ="America/Denver";
    LESS="--raw-control-chars -FXRadeqs -P--Less--?e?x(Next file\: %x):(END).:?pB%pB\%.";
    CLICOLOR_FORCE="yes";
    PAGER="less";
    FZF_CTRL_R_OPTS="--sort --exact";
  };


  services.yabai.enable = true;
  services.yabai.package = pkgs.yabai;
  services.skhd.enable = true;
  services.chunkwm.package = pkgs.chunkwm;
  services.chunkwm.hotload = false;
  services.chunkwm.plugins.dir = "${lib.getOutput "out" pkgs.chunkwm}/lib/chunkwm/plugins";
  services.chunkwm.plugins.list = [ "ffm" "tiling" ];
  services.chunkwm.plugins."tiling".config = ''
    chunkc set global_desktop_mode   bsp
  '';
  services.chunkwm.extraConfig = builtins.readFile <$HOME/.chunkwmrc>;
  services.skhd.skhdConfig = builtins.readFile <$HOME/.skhdrc>;
  services.nix-daemon.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
    enableFzfGit = true;
    autosuggestions.enable = true;
    autosuggestions.extraConfig.ZSH_AUTOSUGGEST_USE_ASYNC = "y";
    enable = lib.mkDefault true;
    histFile = "$HOME/.cache/.zsh_history";
    histSize = 100000;
    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "root" "line" ];
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "sudo" "gitfast" "vim-interaction" "docker" "taskwarrior" "tmux" "fzf" "cargo" "brew" "ripgrep" "zoxide"];
    ohMyZsh.theme  "powerlevel10k";
    setOptions = [
      "DISABLE_COMPFIX"
      "HYPHEN-INSENSITIVE"
      "list_ambiguous"
      "vi"
      "noautomenu"
      "nomenucomplete"
      "AUTO_CD"
      "BANG_HIST"
      "EXTENDED_HISTORY"
      "HIST_EXPIRE_DUPS_FIRST"
      "HIST_FIND_NO_DUPS"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_IGNORE_DUPS"
      "HIST_IGNORE_SPACE"
      "HIST_REDUCE_BLANKS"
      "HIST_SAVE_NO_DUPS"
      "INC_APPEND_HISTORY"
      "SHARE_HISTORY"
    ];
  };
  programs.bat.enable = true;
  programs.broot.enable = true;
  programs.nix-index.enable = true;
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
  programs.tmux.enable = true;
  programs.tmux.enableSensible = true;
  programs.tmux.enableMouse = true;
  programs.tmux.enableFzf = true;
  programs.tmux.enableVim = true;
  programs.tmux.historyLimit = 10000;
  programs.tmux.escapeTime = 0;
    programs.tmux.extraConfig = ''
    set-option -g default-shell /bin/zsh
    set -s set-clipboard on
    set-option -g focus-events on
    # Use vim keybindings
    setw -g mode-keys vi
    set -g status-keys vi
    bind-key -T edit-mode-vi Up send-keys -X history-up
    bind-key -T edit-mode-vi Down send-keys -X history-down
unbind-key -T copy-mode-vi Space     ;   bind-key -T copy-mode-vi v send-keys -X begin-selection
unbind-key -T copy-mode-vi C-v       ;   bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
unbind-key -T copy-mode-vi [         ;   bind-key -T copy-mode-vi [ send-keys -X begin-selection
unbind-key -T copy-mode-vi ]         ;   bind-key -T copy-mode-vi ] send-keys -X copy-selection
# join windows to panes
bind-key j join-pane -s !
bind-key S choose-window 'join-pane -v -s "%%"'
bind-key V choose-window 'join-pane -h -s "%%"'
# listen for activity on all windows
set -g bell-action any
setw -g monitor-activity on
# start window indexing at zero (default)
set -g base-index 0
# xterm-style function key sequences
setw -g xterm-keys on
# control automatic window renaming
setw -g automatic-rename on
# enable wm window titles
set -g set-titles on
set -g set-titles-string "[#S]#I|#W"
# Key bindings
# reload settings
bind-key R source-file ~/.tmux.conf
# Allow clear screen with c-b, c-l
bind C-l send-keys 'C-l';
# navigate panes using jk, and ctrl+jk (no prefix)
bind-key -r j select-pane -t :.-
bind-key -r k select-pane -t :.+
# navigate windows using hl, and ctrl-hl (no prefix)
bind-key -r h select-window -t :-
bind-key -r l select-window -t :+
# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
bind-key -T copy-mode-vi 'C-\' select-pane -l

# keybindings to make resizing easier
bind -r Left resize-pane -L
bind -r Down resize-pane -D
bind -r Up resize-pane -U
bind -r Right resize-pane -R
bind-key Q confirm-before kill-window
set -g mouse on
bind-key A command-prompt "rename-window %%"
bind-key * list-clients
bind-key r refresh-client
bind-key C new-session
# use better mnemonics for horizontal/vertical splits
bind-key - split-window -v
bind-key _ split-window -v
bind-key | split-window -h

set -g display-time 2000

set-option -g status on
set-option -g status-interval 2
set-option -g status-justify "centre"
set-option -g status-left-length 60
set-option -g status-right-length 90
set-option -g status-style "fg=white,bg=black"
set-window-option -g window-status-current-format "#{?window_active,#[fg=brightyellow][#[fg=yellow]*,}#I:#W#{?window_active,#[fg=brightyellow]],}"
set-option -sa terminal-overrides ',alacritty:RGB'
set-option -g default-terminal "alacritty"
set -g default-terminal "alacritty"
set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0


  '';

  environment.shellAliases = {
    ls="ls -G -F";
    l="exa --icons --git-ignore --git -F --extended";
    ll="exa --icons --git-ignore --git -F --extended -l";
    lt="exa --icons --git-ignore --git -F --extended -T";
    llt="exa --icons --git-ignore --git -F --extended -l -T";
    fd="fd -HI"; # when calling the command, search all
    f="\fd"; # default search this dir for files ignoring .gitignore etc
  };

  # Enable full keyboard control
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  # No popup menus when holding down letters
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  # system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  # system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.mineffect = "scale";
  system.defaults.dock.launchanim = false;
  system.defaults.dock.tilesize = 48;
  system.defaults.dock.static-only = true;
  system.defaults.dock.show-process-indicators = true;
  system.defaults.dock.orientation = "bottom";
  system.defaults.dock.showhidden = true;
  system.defaults.dock.mru-spaces = false;

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  # Allow trackpad tap to click
  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadThreeFingerDrag = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  networking.dns = ["1.1.1.1" "8.8.8.8"];

  #nix.useDaemon = false;
  #system.stateVersion = 4;
  nix.maxJobs = 4;
  nix.buildCores = 4;
}

