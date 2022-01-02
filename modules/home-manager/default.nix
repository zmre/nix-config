{ inputs, config, pkgs, ... }:
let
  homeDir = config.home.homeDirectory;
  defaultPkgs = with pkgs.stable; [
    fd
    fzy
    tree-sitter
    ripgrep
    curl
    atool
    file
    ranger
    jq
    du-dust
    lf # file explorer
    highlight # code coloring in lf
    poppler_utils # for pdf2text in lf
    mediainfo # used by lf
    exiftool # used by lf
    ueberzug # for terminal image previews
    glow # view markdown file or dir
    mdcat # colorize markdown
    neofetch # display key software/version info in term
    vimv # shell script to bulk rename
    html2text
    bottom
    exif
    niv # TODO: do I need this now that I'm using flakes?
    youtube-dl
    vulnix # check for live nix apps that are listed in NVD
    tickrs # track stocks
  ];
  cPkgs = with pkgs.stable; [
    automake
    autoconf
    gcc
    gnumake
    cmake
    pkg-config
    glib
    libtool
  ];
  # live dangerously here with unstable
  luaPkgs = with pkgs; [ sumneko-lua-language-server luaformatter ];
  # using unstable in my home profile for nix commands
  nixEditorPkgs = with pkgs; [ nix nixfmt nixpkgs-fmt rnix-lsp ];
  # live dangerously here with unstable
  rustPkgs = with pkgs; [ cargo rustfmt rust-analyzer rustc ];
  # live dangerously here with unstable
  typescriptPkgs = with pkgs.nodePackages; [
    typescript
    typescript-language-server
    yarn
    diagnostic-languageserver
    eslint_d
  ];
  networkPkgs = with pkgs.stable; [ traceroute mtr iftop ];
  guiPkgs = with pkgs; [ neovide ];

in
{
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
  home.stateVersion = "21.11";
  home.packages = defaultPkgs ++ cPkgs ++ luaPkgs ++ nixEditorPkgs ++ rustPkgs
    ++ typescriptPkgs ++ guiPkgs ++ networkPkgs;

  # TODO: comma, gnupg?, ffmpeg?

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
  home.file.".p10k.zsh".source = ./dotfiles/p10k.zsh;
  home.file.".config/nvim/lua/options.lua".source =
    ./dotfiles/nvim/lua/options.lua;
  home.file.".config/nvim/lua/abbreviations.lua".source =
    ./dotfiles/nvim/lua/abbreviations.lua;
  home.file.".config/nvim/lua/filetypes.lua".source =
    ./dotfiles/nvim/lua/filetypes.lua;
  home.file.".config/nvim/lua/mappings.lua".source =
    ./dotfiles/nvim/lua/mappings.lua;
  home.file.".config/nvim/lua/tools.lua".source = ./dotfiles/nvim/lua/tools.lua;
  home.file.".config/nvim/lua/plugins.lua".source =
    ./dotfiles/nvim/lua/plugins.lua;
  home.file.".config/nvim/vim/colors.vim".source =
    ./dotfiles/nvim/vim/colors.vim;
  home.file.".config/lf/lfrc".source = ./dotfiles/lfrc;
  home.file.".config/lf/previewer.sh".source = ./dotfiles/previewer.sh;
  home.file.".config/lf/pager.sh".source = ./dotfiles/pager.sh;
  home.file.".config/lf/lficons.sh".source = ./dotfiles/lficons.sh;
  home.file.".wallpaper.jpg".source = ./wallpaper/castle2.jpg;
  home.file.".lockpaper.png".source = ./wallpaper/kali.png;
  #home.file.".tmux.conf".source =
  #"${config.home-manager-files}/.config/tmux/tmux.conf";
  #home.file.".gitignore".source =
  #"${config.home-manager-files}/.config/git/ignore";

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
        # search for link with / then hit enter to follow
        "<return>" = "follow-selected";
      };
      prompt = { "<Ctrl-y>" = "prompt-yes"; };
      insert = {
        "<Ctrl-h>" = "fake-key <Backspace>";
        "<Ctrl-a>" = "fake-key <Home>";
        "<Ctrl-e>" = "fake-key <End>";
        "<Ctrl-b>" = "fake-key <Left>";
        "<Mod1-b>" = "fake-key <Ctrl-Left>";
        "<Ctrl-f>" = "fake-key <Right>";
        "<Mod1-f>" = "fake-key <Ctrl-Right>";
        "<Ctrl-p>" = "fake-key <Up>";
        "<Ctrl-n>" = "fake-key <Down>";
        "<Mod1-d>" = "fake-key <Ctrl-Delete>";
        "<Ctrl-d>" = "fake-key <Delete>";
        "<Ctrl-w>" = "fake-key <Ctrl-Backspace>";
        "<Ctrl-u>" = "fake-key <Shift-Home><Delete>";
        "<Ctrl-k>" = "fake-key <Shift-End><Delete>";
        "<Ctrl-x><Ctrl-e>" = "open-editor";
      };
    };
    settings = {
      confirm_quit = [ "downloads" ]; # only confirm if downloads in progress
      content.blocking.enabled = true;
      content.blocking.method = "both";
      content.blocking.hosts.block_subdomains = true;
      content.default_encoding = "utf-8";
      content.geolocation = false;
      content.cookies.accept = "no-3rdparty";
      # might break some sites; stops fingerprinting
      content.canvas_reading = false;
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
      completion.shrink = true;
      colors.webpage.preferred_color_scheme = "dark";
      colors.webpage.darkmode.enabled = true;
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
    # these create :whatever commands
    aliases = {
      # bookmarklet copied from getpocket.com/add/?ep=1
      pocket =
        "jseval --url javascript:(function()%7Bvar%20e=function(t,n,r,i,s)%7Bvar%20o=[5725664,2839244,3201831,4395922,8906499,4608765,5885226,5372109,1439837,3633248];var%20i=i%7C%7C0,u=0,n=n%7C%7C[],r=r%7C%7C0,s=s%7C%7C0;var%20a=%7B'a':97,'b':98,'c':99,'d':100,'e':101,'f':102,'g':103,'h':104,'i':105,'j':106,'k':107,'l':108,'m':109,'n':110,'o':111,'p':112,'q':113,'r':114,'s':115,'t':116,'u':117,'v':118,'w':119,'x':120,'y':121,'z':122,'A':65,'B':66,'C':67,'D':68,'E':69,'F':70,'G':71,'H':72,'I':73,'J':74,'K':75,'L':76,'M':77,'N':78,'O':79,'P':80,'Q':81,'R':82,'S':83,'T':84,'U':85,'V':86,'W':87,'X':88,'Y':89,'Z':90,'0':48,'1':49,'2':50,'3':51,'4':52,'5':53,'6':54,'7':55,'8':56,'9':57,'%5C/':47,':':58,'?':63,'=':61,'-':45,'_':95,'&':38,'$':36,'!':33,'.':46%7D;if(!s%7C%7Cs==0)%7Bt=o[0]+t%7Dfor(var%20f=0;f%3Ct.length;f++)%7Bvar%20l=function(e,t)%7Breturn%20a[e[t]]?a[e[t]]:e.charCodeAt(t)%7D(t,f);if(!l*1)l=3;var%20c=l*(o[i]+l*o[u%25o.length]);n[r]=(n[r]?n[r]+c:c)+s+u;var%20p=c%25(50*1);if(n[p])%7Bvar%20d=n[r];n[r]=n[p];n[p]=d%7Du+=c;r=r==50?0:r+1;i=i==o.length-1?0:i+1%7Dif(s==193)%7Bvar%20v='';for(var%20f=0;f%3Cn.length;f++)%7Bv+=String.fromCharCode(n[f]%25(25*1)+97)%7Do=function()%7B%7D;return%20v+'c7a8217062'%7Delse%7Breturn%20e(u+'',n,r,i,s+1)%7D%7D;var%20t=document,n=t.location.href,r=t.title;var%20i=e(n);var%20s=t.createElement('script');s.type='text/javascript';s.src='https://getpocket.com/b/r4.js?h='+i+'&u='+encodeURIComponent(n)+'&t='+encodeURIComponent(r);e=i=function()%7B%7D;var%20o=t.getElementsByTagName('head')[0]%7C%7Ct.documentElement;o.appendChild(s)%7D)()";
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
      yt = "https://www.youtube.com/results?search_query={}";
    };
    extraConfig = ''
      # stolen from reddit; will block or allow skip of ads on youtube
      from qutebrowser.api import interceptor

      def filter_yt(info: interceptor.Request):
          """Block the given request if necessary."""
          url = info.request_url
          if (url.host() == 'www.youtube.com' and url.path() == '/get_video_info' and '&adformat=' in url.query()):
              info.block()

      interceptor.register(filter_yt)

      ${builtins.readFile ./dotfiles/qutebrowser-theme-onedark.py}
    '';
  };

  # Backup browser for when Qutebrowser doesn't work as expected
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
      "devtools.theme" = "dark";
      "extensions.pocket.enabled" = true;
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

    # going unstable here; living dangerously
    plugins = with pkgs.vimPlugins; [
      # Syntax / Language Support ##########################
      vim-polyglot # lazy load all the syntax plugins for all the languages
      #rust-vim # this is included in vim-polyglot
      rust-tools-nvim # lsp stuff and more for rust
      crates-nvim # inline intelligence for Cargo.toml
      nvim-lspconfig # setup LSP
      # lspsaga isn't checking capabilities so is giving me errors for some languages.
      # try again in awhile.
      #lspsaga-nvim # makes LSP stuff look nicer and easier to use
      # using lightbulb as an alternative to saga
      nvim-lightbulb
      lspkind-nvim # adds more icons into dropdown selections
      lsp_signature-nvim # as you type hitns on function parameters
      # damn thing is throwing errors when I open nix files. apparently thinks
      # everything is typescript
      #nvim-lsp-ts-utils # typescript lsp
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
      source ${inputs.gitstatus.outPath}/gitstatus.plugin.zsh
      source ${inputs.powerlevel10k.outPath}/powerlevel10k.zsh-theme
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
      source ${./dotfiles/p10k.zsh}
    '';
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
        "nvim $(realpath /etc/nixos/configuration.nix) ; sudo nixos-rebuild switch --flake ~/.config/nixpkgs/.#";
      nixedit =
        "nvim ~/.config/nixpkgs/home.nix ; sudo nixos-rebuild switch --flake ~/.config/nixpkgs/.#";
      qp = ''
        qutebrowser --temp-basedir --set content.private_browsing true --set colors.tabs.bar.bg "#552222" --config-py "$HOME/.config/qutebrowser/config.py" --qt-arg name "qp,qp"'';
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
      init.defaultBranch = "main";
      http.sslVerify = true;
      commit.verbose = true;
      credential.helper =
        if pkgs.stdenvNoCC.isDarwin then
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
    extraConfig = ''
      ${builtins.readFile ./dotfiles/tmux.conf}
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

  # Need to set this up per device... just install it and let config be manual
  services.syncthing = {
    enable = true;
    tray.enable = false;
  };

}
