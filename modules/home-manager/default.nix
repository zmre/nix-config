{
  inputs,
  config,
  pkgs,
  username,
  lib,
  ...
}: let
  defaultPkgs = with pkgs.stable; [
    # filesystem
    fd
    ripgrep
    du-dust
    fzy
    curl
    duf # df alternative showing free disk space
    fswatch
    tree
    chkrootkit

    # compression
    atool
    unzip
    gzip
    xz
    zip

    # file viewers
    pkgs.pwnvim # moved my neovim config to its own repo for atomic management and install
    less
    page # like less, but uses nvim, which is handy for selecting out text and such
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
    rich-cli # used by lf (experimenting with mdcat replacement)
    exif
    glow # browse markdown dirs
    mdcat # colorize markdown
    html2text
    #pkgs.ctpv
    pkgs.marp-cli # convert markdown to html slides
    #pkgs.gdrive3
    pkgs.dashing # generate dash docs from html

    # network
    gping
    bandwhich # bandwidth monitor by process
    #pkgs.sniffnet # x-platform gui traffic monitor (rust)
    # not building on m1 right now
    #bmon # bandwidth monitor by interface
    static-web-server # serve local static files
    aria # cli downloader
    ncftp
    hostname
    trippy # mtr alternative
    xh # rust version of httpie / better curl

    # misc
    pkgs.ironhide # rust version of IronCore's ironhide
    pkgs.devenv # quick setup of dev envs for projects
    neofetch # display key software/version info in term
    #nodePackages.readability-cli # quick commandline website article read
    vimv # shell script to bulk rename
    pkgs.btop # currently like this better than bottom and htop
    #youtube-dl replaced by yt-dlp
    pkgs.yt-dlp
    vulnix # check for live nix apps that are listed in NVD
    pkgs.tickrs # track stocks
    #taskwarrior-tui
    aspell # spell checker
    kalker # cli calculator; alt. to bc and calc
    rink # calculator for unit conversions
    nix-tree # explore dependencies
    asciinema # terminal screencast
    ctags
    catimg # ascii rendering of any image in terminal x-pltfrm
    fortune
    ipcalc
    kondo # free disk space by cleaning project build dirs
    ncspot # control spotify
    optipng
    pkgs.hackernews-tui
    procps
    pstree
    pkgs.gtm-okr
    pkgs.babble-cli # twitter tui
    pkgs.toot # mastodon tui
    yubikey-manager # cli for yubikey
    pkgs.zk # cli for indexing markdown files
    pastel # cli for color manipulation
    pkgs.kopia # deduping backup
    pkgs.nps # quick nix packages search
    gnugrep
    pkgs.enola # sherlock-like tool
    zsh-fzf-tab

    #pkgs.qutebrowser
  ];
  # using unstable in my home profile for nix commands
  # nixEditorPkgs = with pkgs; [ nix statix ];

  networkPkgs = with pkgs.stable; [mtr iftop];
  guiPkgs = with pkgs;
    [
      element-desktop
      pkgs.pwneovide # wrapper makes a macos app for launching (and ensures it calls pwnvim)
      #dbeaver # database sql manager with er diagrams
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin
    [
      colima # command line docker server replacement
      docker
      utm # utm is a qemu wrapper gui for mac only
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
  home.packages = defaultPkgs ++ guiPkgs ++ networkPkgs;

  home.sessionVariables = {
    NIX_PATH = "nixpkgs=${inputs.nixpkgs-unstable}:stable=${inputs.nixpkgs-stable}\${NIX_PATH:+:}$NIX_PATH";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    #TERM = "xterm-256color";
    KEYTIMEOUT = 1;
    EDITOR = "nvim";
    VISUAL = "nvim";
    GIT_EDITOR = "nvim";
    LS_COLORS = "no=00:fi=00:di=01;34:ln=35;40:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:";
    LSCOLORS = "ExfxcxdxCxegedabagacad";
    FIGNORE = "*.o:~:Application Scripts:CVS:.git";
    TZ = "America/Denver";
    LESS = "--raw-control-chars -FXRadeqs -P--Less--?e?x(Next file: %x):(END).:?pB%pB%.";
    CLICOLOR = 1;
    CLICOLOR_FORCE = "yes";
    PAGER = "page -WO -q 90000";
    # Add colors to man pages
    MANPAGER = "less -R --use-color -Dd+r -Du+b +Gg -M -s";
    SYSTEMD_COLORS = "true";
    COLORTERM = "truecolor";
    FZF_CTRL_R_OPTS = "--sort --exact";
    BROWSER = "qutebrowser";
    TERMINAL = "alacritty";
    HOMEBREW_NO_AUTO_UPDATE = 1;
    #LIBVA_DRIVER_NAME="iHD";
    ZK_NOTEBOOK_DIR =
      if pkgs.stdenvNoCC.isDarwin
      then "/Users/${username}/Library/Containers/co.noteplan.NotePlan3/Data/Library/Application Support/co.noteplan.NotePlan3"
      else "/home/${username}/Notes";
  };

  home.file =
    {
      ".inputrc".text = ''
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
      ".direnvrc".text = ''
        source ~/.config/direnv/direnvrc
      '';
      # ".p10k.zsh".source = ./dotfiles/p10k.zsh;
      ".wallpaper.jpg".source = ./wallpaper/castle2.jpg;
      ".lockpaper.png".source = ./wallpaper/kali.png;

      # terminfo to allow rich handling of italics, 256 colors, etc.
      # these files were generated from the dotfiles dir which has a terminfo.src
      # downloaded from https://invisible-island.net/datafiles/current/terminfo.src.gz
      # the terminfo definitions were created with the command:
      # tic -xe alacritty,alacritty-direct,kitty,kitty-direct,tmux-256color -o terminfo terminfo.src
      # Also did this for xterm-kitty (from within kitty so TERMINFO is set)
      # tic -x -o ~/.terminfo $TERMINFO/kitty.terminfo
      # Then copied out the resulting ~/.terminfo/78/xterm-kitty file
      # I'm not sure if this is OS dependent. For now, only doing this on Darwin. Possibly I should generate
      # on each local system first in a derivation
      ".terminfo/61/alacritty".source = ./dotfiles/terminfo/61/alacritty;
      ".terminfo/61/alacritty-direct".source =
        ./dotfiles/terminfo/61/alacritty-direct;
      ".terminfo/6b/kitty".source = ./dotfiles/terminfo/6b/kitty;
      ".terminfo/6b/kitty-direct".source =
        ./dotfiles/terminfo/6b/kitty-direct;
      ".terminfo/74/tmux-256color".source =
        ./dotfiles/terminfo/74/tmux-256color;
      ".terminfo/78/xterm-kitty".source =
        ./dotfiles/terminfo/78/xterm-kitty;
      ".terminfo/x/xterm-kitty".source =
        ./dotfiles/terminfo/78/xterm-kitty;
      ".config/lf/lfimg".source = ./dotfiles/lf/lfimg;
      ".config/lf/lf_kitty_preview".source =
        ./dotfiles/lf/lf_kitty_preview;
      ".config/lf/pv.sh".source = ./dotfiles/lf/pv.sh;
      ".config/lf/cls.sh".source = ./dotfiles/lf/cls.sh;
      #".config/lf/previewer.sh".source = ./dotfiles/lf/previewer.sh;
      ".config/lf/pager.sh".source = ./dotfiles/lf/pager.sh;
      ".config/lf/lficons.sh".source = ./dotfiles/lf/lficons.sh;
      # Config for hackernews-tui to make it darker
      ".config/hn-tui.toml".text = ''
        [theme.palette]
        background = "#242424"
        foreground = "#f6f6ef"
        selection_background = "#4a4c4c"
        selection_foreground = "#d8dad6"
      '';
      # Prose linting
      "${config.xdg.configHome}/proselint/config.json".text = ''
        {
          "checks": {
            "typography.symbols.curly_quotes": false,
            "typography.symbols.ellipsis": false
          }
        }
      '';
      ".styles".source = ./dotfiles/vale-styles;
      ".vale.ini".text = ''
        StylesPath = .styles

        MinAlertLevel = suggestion

        Packages = proselint, alex, Readability

        [*]
        BasedOnStyles = Vale, proselint
        IgnoredScopes = code, tt
        SkippedScopes = script, style, pre, figure
        Google.FirstPerson = NO
        Google.We = NO
        Google.Acronyms = NO
        Google.Units = NO
        Google.Spacing = NO
        Google.Exclamation = NO
        Google.Headings = NO
        Google.Parens = NO
        Google.DateFormat = NO
        Google.Ellipses = NO
        proselint.Typography = NO
        proselint.DateCase = NO
        Vale.Spelling = NO
      '';
      ".config/kitty/startup.session".text = ''
        new_tab
        cd ~
        launch zsh

        new_tab notes
        cd ~/Library/Containers/co.noteplan.NotePlan3/Data/Library/Application Support/co.noteplan.NotePlan3
        launch zsh

        new_tab news
        layout grid
        launch zsh -i -c tickrs
        launch zsh
        launch zsh -i -c "watch -n 120 -c \"/opt/homebrew/bin/icalBuddy -tf %H:%M -n -f -eep notes -ec 'Outschool Schedule,HomeAW,Contacts,Birthdays,Found in Natural Language' eventsToday\""
        launch zsh -i -c hackernews_tui
        new_tab svelte
        cd ~/src/icl/website.worktree
      '';
    }
    // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
      "Library/KeyBindings/DefaultKeyBinding.dict".source = ./dotfiles/DefaultKeyBinding.dict;
      # company colors -- may still need to "install" them from a color picker window
      "Library/Colors/IronCore-Branding-June-17.clr".source = ./dotfiles/IronCore-Branding-June-17.clr;
      "Library/Preferences/espanso/match/base.yml".text = pkgs.lib.generators.toYAML {} {
        matches = [
          {
            trigger = "lorem1";
            replace = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua";
          }
          {
            trigger = "lorem2";
            replace = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
          }
          {
            trigger = "lorem3";
            replace = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
          }
          {
            trigger = "icphone";
            replace = "415.968.9607";
          }
          {
            trigger = ":checkbox:";
            replace = "⬜️";
          }
          {
            trigger = ":checked:";
            replace = "✅";
          }
          {
            trigger = ":checkmark:";
            replace = "✓";
          }
          {
            trigger = "acmlink";
            replace = "https://dl.acm.org/citation.cfm?id=3201602";
          }
          {
            trigger = "icaddr1";
            replace = "1750 30th Street #500";
          }
          {
            trigger = "icaddr2";
            replace = "Boulder, CO 80301-1029";
          }
          {
            trigger = "icoffice1";
            replace = "1919 14th Street, 7th Floor";
          }
          {
            trigger = "icoffice2";
            replace = "Boulder, CO 80302";
          }
          {
            trigger = "..p";
            replace = "..Patrick";
          }
          {
            trigger = "myskype";
            replace = "303.731.3155";
          }
          {
            trigger = "-icc";
            replace = "ironcorelabs.com";
          }
          {
            trigger = "--icl";
            replace = "IronCore Labs";
          }
          {
            trigger = ".zsg";
            replace = ".zmre@spamgourmet.com";
          }
          {
            trigger = "mycal";
            replace = "https://app.hubspot.com/meetings/patrick-walsh";
          }
          {
            trigger = "p@i";
            replace = "patrick.walsh@ironcorelabs.com";
          }
          {
            trigger = "p@w";
            replace = "pwalsh@well.com";
          }
          # {
          #   trigger = "--sig";
          #   replace = ''
          #     --
          #     Patrick Walsh  ●  CEO
          #     patrick.walsh@ironcorelabs.com  ●  @zmre
          #
          #     IronCore Labs
          #     Strategic privacy for modern SaaS.
          #     https://ironcorelabs.com  ●  @ironcorelabs  ●  415.968.9607
          #   '';
          # }
          {
            trigger = "--sig";
            html = ''
              <p>--&nbsp;</p>
              <p style="font-family:Helvetica,Arial,sans-serif;font-size:14px;"><b>Patrick Walsh</b>&nbsp;&nbsp;<span style="color:red;">&bull;</span>&nbsp;&nbsp;Co-founder and CEO<br/>
              patrick.walsh@ironcorelabs.com&nbsp;&nbsp;<span style="color:red;">&bull;</span>&nbsp;&nbsp;@zmre<br/>
              <br/>
              <b>IronCore Labs</b><br/>
              Real data protection for cloud apps and AI<br/>
              <a href="https://ironcorelabs.com/">ironcorelabs.com</a>&nbsp;&nbsp;<span style="color:red;">&bull;</span>&nbsp;&nbsp;@ironcorelabs&nbsp;&nbsp;<span style="color:red;">&bull;</span>&nbsp;&nbsp;415.968.9607<br/>
              </p>
              <p style="font-family:Helvetica,Arial,sans-serif;font-size:14px;color:red;">Sign up for <a style="color:red;font-weight:bold;" href="https://ironcorelabs.com/products/cloaked-ai/">Cloaked AI</a> to protect your AI data</p>
            '';
          }
          {
            trigger = "vcintroreply";
            form = ''
              Thanks, [[introducer]]! (To bcc.)

              Hi [[investor]],

              Nice to meet you and thanks for your interest in talking with us. I'd love to take you through our pitch.  What are some good times for you?  Or alternatively, if you'd prefer, you can grab some time on my calendar directly here: https://app.hubspot.com/meetings/patrick-walsh

              Thanks and I look forward to talking with you soon.

              Regards,

              ..Patrick
            '';
          }
          {
            trigger = "vcintrorequest";
            vars = [
              {
                name = "form";
                type = "form";
                params = {
                  layout = ''
                    Introducer: [[introducer]]
                    Investor: [[investor]]
                    VC Firm: [[firm]]
                    Reason for them: [[reason]]
                    Round size: [[roundsize]]
                    ARR: [[arr]]
                  '';
                  fields = {
                    introducer = {multiline = false;};
                    investor = {multiline = false;};
                    firm = {multiline = false;};
                    reason = {multiline = true;};
                    roundsize = {multiline = false;};
                    arr = {mulitline = false;};
                  };
                };
              }
            ];
            html = ''
              <p>{{form.introducer}}, thanks for offering to introduce us.</p>

              <p>Hi {{form.investor}},</p>

              <p>I'm hoping you're the right person to talk to at {{form.firm}} and that we're a potential fit -- {{form.reason}}</p>

              <p>Here's the quick rundown on IronCore Labs:</p>

              <p><b>Problem:</b></p>

              <p>Today, over half of GenAI projects aren't making it to production because of privacy and security issues (per Gartner). Major companies like Google and Facebook are unable to release new products (ie, Bard and Threads) in the EU because of data privacy issues. But the problem isn't constrained to the EU. 60% of CEOs globally say privacy and security issues are blocking their adoption of new AI capabilities.</p>

              <p><b>Solution:</b></p>

              <p>With our Cloaked AI product, companies can use the latest and best hosted cloud solutions for working with GenAI without leaking their private and confidential data (or their customers'). They can search, chat, prevent hallucinations, leverage facial recognition, and more without any risk to the data involved.</p>

              <p>IronCore <b>unlocks the most valuable AI use cases by freeing companies from the privacy and security issues</b> that are blocking them.</p>

              <p>We're currently raising our Series A. Here are the key details:</p>

              <ul>
              <li><b>Broad Categories:</b> Cybersecurity, Artificial Intelligence, Data Protection, Developer and DevOps Tools, Enterprise</li>
              <li><b>Company progress:</b> ~{{form.progress}}M in ARR with large marquee customers like HubSpot and Zendesk</li>
              <li><b>Round size:</b> {{form.roundsize}}M</li>
              <li><b>AI product readiness:</b> Cloaked AI is currently in beta</li>
              </ul>

              <p>And if that's not enough to get you started, we have a two minute video that's a mini version of our pitch:</p>

              <p>https://docsend.com/view/q6535e3wn65yqiai</p>

              <p>Regards,</p>

              <p>..Patrick</p>
            '';
          }
          {
            # Dates
            trigger = "ddate";
            replace = "{{mydate}}";
            vars = [
              {
                name = "mydate";
                type = "date";
                params = {format = "%Y-%m-%d";};
              }
            ];
          }
          {
            # Shell commands example
            trigger = ":shell";
            replace = "{{output}}";
            vars = [
              {
                name = "output";
                type = "shell";
                params = {cmd = "echo Hello from your shell";};
              }
            ];
          }
        ];
      };
    };

  programs.bat = {
    enable = true;
    #extraPackages = with pkgs.bat-extras; [ batman batgrep ];
    config = {
      theme = "Dracula"; # I like the TwoDark colors better, but want bold/italic in markdown docs
      #pager = "less -FR";
      pager = "page -WO -q 90000";
      italic-text = "always";
      style = "plain"; # no line numbers, git status, etc... more like cat with colors
    };
  };
  programs.nix-index.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = false;
  };
  programs.taskwarrior = {
    enable = false;
    colorTheme = "dark-256";
    dataLocation = "~/.task";
    config = {
      urgency.user.tag.networking.coefficient = -10.0;
      uda.reviewed.type = "date";
      uda.reviewed.label = "Reviewed";
      report._reviewed.description = "Tasksh review report.  Adjust the filter to your needs.";
      report._reviewed.columns = "uuid";
      report._reviewed.sort = "reviewed+,modified+";
      report._reviewed.filter = "( reviewed.none: or reviewed.before:now-6days ) and ( +PENDING or +WAITING )";
      search.case.sensitive = "no";
      # Shortcuts
      alias.dailystatus = "status:completed end.after:today all";
      alias.punt = "modify wait:1d";
      alias.someday = "mod +someday wait:someday";

      # task ready report default with custom columns
      default.command = "ready";
      report.ready.columns = "id,start.active,depends.indicator,project,due.relative,description.desc";
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
      prisma.prisma
      asvetliakov.vscode-neovim
      brettm12345.nixfmt-vscode
      davidanson.vscode-markdownlint
      pkief.material-icon-theme
      dracula-theme.theme-dracula
      eamodio.gitlens # for git blame
      marp-team.marp-vscode # for markdown slides
      pkgs.kubernetes-yaml-formatter # format k8s; from overlays and flake input
      # live share not currently working via nix
      #ms-vsliveshare.vsliveshare # live share coding with others
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
    ];
    userSettings = {
      # Much of the following adapted from https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/settings.json
      "editor.tabSize" = 2;
      "editor.fontLigatures" = true;
      "editor.guides.indentation" = false;
      "editor.insertSpaces" = true;
      "editor.fontFamily" = "'Hasklug Nerd Font', 'JetBrainsMono Nerd Font', 'FiraCode Nerd Font','SF Mono', Menlo, Monaco, 'Courier New', monospace";
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
      "vsintellicode.modify.editor.suggestSelection" = "automaticallyOverrodeDefaultValue";
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
      /*
      "vscode-neovim.neovimInitVimPaths.darwin" = "$HOME/.config/nvim/init.vim";
      "vscode-neovim.neovimInitVimPaths.linux" = "$HOME/.config/nvim/init.vim";
      */
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
            "settings" = {"fontStyle" = "bold";};
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
            "settings" = {"fontStyle" = "italic";};
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
            "settings" = {"fontStyle" = "";};
          }
          {
            "name" = "One Dark bold italic";
            "scope" = ["keyword.other.important"];
            "settings" = {"fontStyle" = "bold italic";};
          }
        ];
      };
    };
  };
  # VSCode whines like a ... I don't know, but a lot when the config file is read-only
  # I want nix to govern the configs, but to let vscode edit it (ephemerally) if I change
  # the zoom or whatever. This hack just copies the symlink to a normal file
  home.activation.vscodeWritableConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    code_dir="$(echo ~/Library)/Application Support/Code/User"
    settings="$code_dir/settings.json"
    settings_nix="$code_dir/settings.nix.json"
    settings_bak="$settings.bak"

    if [ -f "$settings" ] ; then
      echo "activating $settings"

      $DRY_RUN_CMD mv "$settings" "$settings_nix"
      $DRY_RUN_CMD cp -H "$settings_nix" "$settings"
      $DRY_RUN_CMD chmod u+w "$settings"
      $DRY_RUN_CMD rm "$settings_bak"
    fi
  '';

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
    defaultCommand = "\fd --type f --hidden --exclude .git";
    fileWidgetCommand = "\fd --exclude .git --type f"; # for when ctrl-t is pressed
    changeDirWidgetCommand = "\fd --type d --hidden --follow --max-depth 3 --exclude .git";
  };
  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    includes = ["*.conf"];
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
  programs.gh = {
    enable = true;
    # stable is currently failing as of 2022-02-17
    # error: Could not find a version that satisfies the requirement tomlkit<0.8,>=0.7 (from remarshal)
    package = pkgs.gh;
    settings = {git_protocol = "ssh";};
  };
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [thumbnail sponsorblock];
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
      autofit-larger = "100%x95%"; # resize window in case it's larger than W%xH% of the screen
      input-media-keys = "yes"; # enable/disable OSX media keys
      hls-bitrate = "max"; # use max quality for HLS streams

      user-agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:57.0) Gecko/20100101 Firefox/58.0";
    };
    defaultProfiles = ["gpu-hq"];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    # let's the terminal track current working dir but only builds on linux
    enableVteIntegration =
      if pkgs.stdenvNoCC.isDarwin
      then false
      else true;

    history = {
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      save = 10000; # save 10,000 lines of history
    };
    defaultKeymap = "viins";
    # things to add to .zshenv
    envExtra = ''
      # don't use global env as it will slow us down
      skip_global_compinit=1
    '';
    initExtraFirst = ''
      #zmodload zsh/zprof
      # source ${./dotfiles/p10k.zsh}
      # source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      # Prompt stuff
      # if [[ -r "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh" ]]; then
        # source "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh"
      # fi
      source  ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';
    #initExtraBeforeCompInit = "";
    completionInit = ''
      # only update compinit once each day
      # better solution would be to pre-build zcompdump with compinit call then link it in
      # and never recalculate
      autoload -Uz compinit
      for dump in ~/.zcompdump(N.mh+24); do
        compinit
      done
      compinit -C

      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false
      # set descriptions format to enable group support
      zstyle ':completion:*:descriptions' format '[%d]'
      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      # preview directory's content with exa when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      # switch group using `,` and `.`
      zstyle ':fzf-tab:*' switch-group ',' '.'
    '';
    initExtra = ''
      set -o vi
      bindkey -v

      jump_key_places(){
        cd "$(\fd . ~ ~/.config ~/src/sideprojects ~/src/icl ~/src/icl/website ~/src/personal ~/src/gh ~/Sync/Private/Finances ~/Sync/Private ~/Sync/IronCore\ Docs ~/Sync/IronCore\ Docs/Legal ~/Sync/IronCore\ Docs/Finances ~/Sync/IronCore\ Docs/Design ~/Notes ~/Notes/Notes --min-depth 1 --max-depth 1 --type d -L -E .Trash -E @Trash | fzf)"
        zle reset-prompt
      }
      zle -N jump_key_places

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
      bindkey '^f' jump_key_places

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

      # next line makes completions case insensitive
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' completer _extensions _complete _approximate
      zstyle ':completion:*' menu select
      zstyle ':completion:*:manuals'    separate-sections true
      zstyle ':completion:*:manuals.*'  insert-sections   true
      zstyle ':completion:*:man:*'      menu yes select
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.zsh/cache
      zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
      #zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
      zstyle ':completion:*:*:kill:*' menu yes select
      zstyle ':completion:*:kill:*'   force-list always
      zstyle -e ':completion:*:default' list-colors 'reply=("$''${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:''${(s.:.)LS_COLORS}")'

      zmodload -a colors
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS} # complete with same colors as ls
      zstyle ':completion:*:*:*:*:hosts' list-colors '=*=1;36' # bold cyan
      zstyle ':completion:*:*:*:*:users' list-colors '=*=36;40' # dark cyan on black

      setopt list_ambiguous

      zmodload -a autocomplete
      zmodload -a complist

      # Customize fzf plugin to use fd
      # Should default to ignore anything in ~/.gitignore
      #export FZF_DEFAULT_COMMAND='\fd --type f --hidden --exclude .git'
      # Use fd (https://github.com/sharkdp/fd) instead of the default find
      # command for listing path candidates.
      # - The first argument to the function ($1) is the base path to start traversal
      # - See the source code (completion.{bash,zsh}) for the details.
      # _fzf_compgen_path() {
      #   \fd --type d --hidden --follow --max-depth 3 --exclude .git . "$1"
      # }

      # Use fd to generate the list for directory completion
      # _fzf_compgen_dir() {
      #   \fd --type d --hidden --follow --max-depth 3 --exclude .git . "$1"
      # }


      # Per https://github.com/junegunn/fzf/wiki/Configuring-fuzzy-completion
      # Since fzf init comes before this, and we setopt vi, we need to reassign:
      bindkey '^I' fzf-completion

      # Needed for lf to be pretty
      . ~/.config/lf/lficons.sh

      # Setup zoxide
      eval "$(zoxide init zsh)"

      #zprof
    '';
    sessionVariables = {};
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];
    shellAliases =
      {
        c = "clear";
        ls = "ls --color=auto -F";
        l = "eza --icons --git-ignore --git -F";
        ll = "eza --icons --git-ignore --git -F --extended -l";
        lt = "eza --icons --git-ignore --git -F -T";
        llt = "eza --icons --git-ignore --git -F -l -T";
        fd = "\\fd -H -t d"; # default search directories
        f = "\\fd -H"; # default search this dir for files ignoring .gitignore etc
        lf = "~/.config/lf/lfimg";
        nixosedit = "nvim $(realpath /etc/nixos/configuration.nix) ; sudo nixos-rebuild switch --flake ~/.config/nixpkgs/.#";
        nixedit = "nvim ~/.config/nixpkgs/home.nix ; sudo nixos-rebuild switch --flake ~/.config/nixpkgs/.#";
        qp = ''
          qutebrowser --temp-basedir --set content.private_browsing true --set colors.tabs.bar.bg "#552222" --config-py "$HOME/.config/qutebrowser/config.py" --qt-arg name "qp,qp"'';
        calc = "kalker";
        df = "duf";
        # search for a note and with ctrl-n, create it if not found
        # add subdir as needed like "n meetings" or "n wiki"
        n = "zk edit --interactive";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        # Figure out the uniform type identifiers and uri schemes of a file (must specify the file)
        # for use in SwiftDefaultApps
        checktype = "mdls -name kMDItemContentType -name kMDItemContentTypeTree -name kMDItemKind";
        # dwupdate = "pushd ~/.config/nixpkgs ; nix flake update ; /opt/homebrew/bin/brew update; popd ; dwswitch ; /opt/homebrew/bin/brew upgrade ; /opt/homebrew/bin/brew upgrade --cask --greedy; dwshowupdates; popd";
        # brew update should no longer be needed; and brew upgrade should just happen, I think, but I might need to specify greedy per package
        dwupdate = "pushd ~/.config/nixpkgs ; nix flake update ; popd ; dwswitch ; dwshowupdates; popd";
        dwswitch = "pushd ~; cachix watch-exec zmre darwin-rebuild -- switch --flake ~/.config/nixpkgs/.#$(hostname -s) ; popd";
        dwswitchx = "pushd ~; darwin-rebuild switch --flake ~/.config/nixpkgs/.#$(hostname -s) ; popd";
        dwclean = "pushd ~; sudo nix-env --delete-generations +7 --profile /nix/var/nix/profiles/system; sudo nix-collect-garbage --delete-older-than 30d ; nix store optimise ; popd";
        dwupcheck = "pushd ~/.config/nixpkgs ; nix flake update ; darwin-rebuild build --flake ~/.config/nixpkgs/.#$(hostname -s) && nix store diff-closures /nix/var/nix/profiles/system ~/.config/nixpkgs/result; popd"; # todo: prefer nvd?
        # i use the zsh shell out in case anyone blindly copies this into their bash or fish profile since syntax is zsh specific
        dwshowupdates = ''
          zsh -c "nix store diff-closures /nix/var/nix/profiles/system-*-link(om[2]) /nix/var/nix/profiles/system-*-link(om[1])"'';
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
        hmswitch = ''
          nix-shell -p home-manager --run "home-manager switch --flake ~/.config/nixpkgs/.#$(hostname -s)"'';
        noupdate = "pushd ~/.config/nixpkgs; nix flake update; popd; noswitch";
        noswitch = "pushd ~; sudo cachix watch-exec zmre nixos-rebuild -- switch --flake ~/.config/nixpkgs/.# ; popd";
      };
  };

  programs.eza.enable = true; # replacement for "exa" which is now archived
  /*
  programs.pistol = {
    # I've gone back to my pv.sh script for now
    enable = false;
    associations = [
      {
        mime = "text/*";
        command = "bat --paging=never --color=always %pistol-filename%";
      }
      {
        mime = "image/*";
        command = "kitty +kitten icat --silent --transfer-mode=stream --stdin=no %pistol-filename%";
      }
    ];
  };
  */
  # my preferred file explorer; mnemonic: list files

  programs.nushell = {
    enable = true;
    configFile.text = ''
      let-env config = {
        ls: {
          use_ls_colors: true
          clickable_links: true
        }
        rm: {
          always_trash: false
        }
        use_grid_icons: true
        footer_mode: "25" # always, never, number_of_rows, auto
        float_precision: 2
        use_ansi_coloring: true
        filesize: {
          metric: true # true => (KB, MB, GB), false => (KiB, MiB, GiB)
          format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
        }
        edit_mode: vi # emacs, vi
        history: {
          max_size: 10000 # Session has to be reloaded for this to take effect
          file_format: "plaintext" # "sqlite" or "plaintext"
          sync_on_enter: true # Enable to share the history between multiple sessions, else you have to close the session to persist history to file
        }
        shell_integration: true # enables terminal markers and a workaround to arrow keys stop working issue
        cd: {
          abbreviations: false # set to true to allow you to do things like cd s/o/f and nushell expand it to cd some/other/folder
        }
        completions: {
          case_sensitive: false # set to true to enable case-sensitive completions
          quick: true  # set this to false to prevent auto-selecting completions when only one remains
          partial: true  # set this to false to prevent partial filling of the prompt
          algorithm: "prefix"  # prefix, fuzzy
          external: {
            enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up my be very slow
            max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
          }
        }
        # A strategy of managing table view in case of limited space.
        table: {
          index_mode: auto # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
          mode: none # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
          trim: {
            methodology: wrapping, # truncating
            # A strategy which will be used by 'wrapping' methodology
            wrapping_try_keep_words: true,
            # A suffix which will be used with 'truncating' methodology
            # truncating_suffix: "..."
          }
        }
        show_banner: false # true or false to enable or disable the banner
        render_right_prompt_on_last_line: false
      }
      #source ~/.zoxide.nu

      # Initialize hook to add new entries to the database.
      if (not ($env | default false __zoxide_hooked | get __zoxide_hooked)) {
        let-env __zoxide_hooked = true
        let-env config = ($env | default {} config).config
        let-env config = ($env.config | default {} hooks)
        let-env config = ($env.config | update hooks ($env.config.hooks | default [] pre_prompt))
        let-env config = ($env.config | update hooks.pre_prompt ($env.config.hooks.pre_prompt | append {||
          zoxide add -- $env.PWD
        }))
      }

      # Jump to a directory using only keywords.
      def-env __zoxide_z [...rest:string] {
        # `z -` does not work yet, see https://github.com/nushell/nushell/issues/4769
        let arg0 = ($rest | append '~').0
        let path = if (($rest | length) <= 1) and ($arg0 == '-' or ($arg0 | path expand | path type) == dir) {
          $arg0
        } else {
          (zoxide query --exclude $env.PWD -- $rest | str trim -r -c "\n")
        }
        cd $path
      }

      # Jump to a directory using interactive search.
      def-env __zoxide_zi  [...rest:string] {
        cd $'(zoxide query -i -- $rest | str trim -r -c "\n")'
      }

      alias z = __zoxide_z
      alias zi = __zoxide_zi

      let-env STARSHIP_SHELL = "nu"
      let-env STARSHIP_SESSION_KEY = (random chars -l 16)
      let-env PROMPT_MULTILINE_INDICATOR = (^starship prompt --continuation)
      let-env PROMPT_INDICATOR = ""
      let-env PROMPT_INDICATOR_VI_INSERT = {|| "" }
      let-env PROMPT_INDICATOR_VI_NORMAL = {|| "〉" }
      let-env PROMPT_COMMAND = {||
        # jobs are not supported
        let width = (term size).columns
        ^starship prompt $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)"
      }
      let-env PROMPT_COMMAND_RIGHT = {||
        let width = (term size).columns
        ^starship prompt --right $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)"
      }
      #source ~/.cache/starship/init.nu
      # Taken from the docs at https://www.nushell.sh/book/configuration.html#macos-keeping-usr-bin-open-as-open
      def nuopen [arg, --raw (-r)] { if $raw { open -r $arg } else { open $arg } }
      alias open = ^open

    '';
    envFile.text = ''
      # The prompt indicators are environmental variables that represent
      # the state of the prompt
      #let-env PROMPT_INDICATOR = "❯ "
      #let-env PROMPT_INDICATOR_VI_INSERT = "❯ "
      #let-env PROMPT_INDICATOR_VI_NORMAL = "❮ "
      #let-env PROMPT_MULTILINE_INDICATOR = ""

      let-env EDITOR = "nvim"

      zoxide init nushell --hook prompt | save -f ~/.zoxide.nu

      #mkdir ~/.cache/starship
      #starship init nu | save -f ~/.cache/starship/init.nu
    '';
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration =
      false; # I've manually integrated because of bugs 2023-04-05
    enableZshIntegration =
      true; # nope. I'm happy with the smokin speed of powerlevel10k in zsh
    enableBashIntegration = true;
    settings = {
      format = pkgs.lib.concatStrings [
        "$os"
        "$shell"
        "$username"
        "$hostname"
        "$singularity"
        "$kubernetes"
        "$directory"
        "$vcsh"
        "$fossil_branch"
        "$git_branch"
        # "$git_commit"
        # "$git_state"
        # "$git_status"
        # "$git_metrics"
        "$hg_branch"
        "$pijul_channel"
        "$sudo"
        "$jobs"
        "$line_break"
        "$battery"
        "$time"
        "$status"
        "$container"
        "$character"
      ];
      right_format = pkgs.lib.concatStrings [
        "$cmd_duration"
        "$shlvl"
        "$docker_context"
        "$package"
        "$c"
        "$cmake"
        "$daml"
        "$dart"
        "$deno"
        "$dotnet"
        "$elixir"
        "$elm"
        "$erlang"
        "$fennel"
        "$golang"
        "$guix_shell"
        "$haskell"
        "$haxe"
        "$helm"
        "$java"
        "$julia"
        "$kotlin"
        "$gradle"
        "$lua"
        "$nim"
        "$nodejs"
        "$ocaml"
        "$opa"
        "$perl"
        "$php"
        "$pulumi"
        "$purescript"
        "$python"
        "$raku"
        "$rlang"
        "$red"
        "$ruby"
        "$rust"
        "$scala"
        "$swift"
        "$terraform"
        "$vlang"
        "$vagrant"
        "$zig"
        "$buf"
        "$nix_shell"
        "$conda"
        "$meson"
        "$spack"
        "$memory_usage"
        "$aws"
        "$gcloud"
        "$openstack"
        "$azure"
        "$env_var"
        "$crystal"
        "$custom"
      ];
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vicmd_symbol = "[❮](green)";
      };
      scan_timeout = 30;
      add_newline = true;
      gcloud.disabled = true;
      aws.disabled = true;
      os.disabled = false;
      os.symbols.Macos = "";
      kubernetes = {
        disabled = false;
        context_aliases = {
          "gke_.*_(?P<var_cluster>[\\w-]+)" = "$var_cluster";
        };
      };
      git_status.style = "blue";
      git_metrics.disabled = false;
      git_branch.style = "bright-black";
      git_branch.format = "[  ](bright-black)[$symbol$branch(:$remote_branch)]($style) ";
      time.disabled = true;
      directory = {
        format = "[    ](bright-black)[$path]($style)[$read_only]($read_only_style)";
        truncation_length = 4;
        truncation_symbol = "…/";
        style = "bold blue"; # cyan
        truncate_to_repo = false;
      };
      directory.substitutions = {
        Documents = " ";
        Downloads = " ";
        Music = " ";
        Pictures = " ";
        "Library/Containers/co.noteplan.NotePlan3/Data/Library/Application Support/co.noteplan.NotePlan3" = "Notes";
      };
      package.disabled = true;
      package.format = "version [$version](bold green) ";
      nix_shell.symbol = " ";
      rust.symbol = " ";
      shell = {
        disabled = false;
        format = "[$indicator]($style)";
        style = "bright-black";
        bash_indicator = " bsh";
        nu_indicator = " nu";
        fish_indicator = " ";
        zsh_indicator = ""; # don't show when in my default shell type
        unknown_indicator = " ?";
        powershell_indicator = " _";
      };
      cmd_duration = {
        format = "[$duration]($style)   ";
        style = "bold yellow";
        min_time_to_notify = 5000;
      };
      jobs = {
        symbol = "";
        style = "bold red";
        number_threshold = 1;
        format = "[$symbol]($style)";
      };
    };
  };

  programs.lf = {
    enable = true;
    settings = {
      icons = true;
      incsearch = true;
      ifs = "\n";
      findlen = 2;
      scrolloff = 3;
      drawbox = true;
      promptfmt = "\\033[1;38;5;51m[\\033[38;5;39m%u\\033[38;5;51m@\\033[38;5;39m%h\\033[38;5;51m] \\033[0;38;5;49m%w/\\033[38;5;48m%f\\033[0m";
    };
    extraConfig = ''
      set incfilter
      set mouse
      set truncatechar ⋯
      set cleaner ${./dotfiles/lf/cls.sh}
    '';
    previewer = {
      keybinding = "i";
      source = ./dotfiles/lf/pv.sh;
      # source = "${pkgs.pistol}/bin/pistol";
      # source = ./dotfiles/lf/lf_kitty_preview;
    };
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
      #i = "!~/.config/lf/pager.sh $f"; # mnemonic: info
      # use the system open command
      o = "open";
      I = "!/usr/bin/qlmanage -p $f";
      "<c-z>" = "$ kill -STOP $PPID";
      "gr" = "fzf_search"; # ripgrep search
      "gd" = "fd_dir"; # mnemonic: go find dir
      "gf" = "f_file"; # mnemonic: go find file
      "gz" = "push :z<space>"; # mnemonic: go zoxide
      "R" = "vi-rename";
      "<enter>" = ":printfx; quit";
    };
  };
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Patrick Walsh";
    userEmail = "patrick.walsh@ironcorelabs.com";
    aliases = {
      gone = ''
        ! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == "[gone]" {print $1}' | xargs -r git branch -D'';
      tatus = "status";
      co = "checkout";
      br = "branch";
      st = "status -sb";
      wtf = "!git-wtf";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --topo-order --date=relative";
      gl = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --topo-order --date=relative";
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
    extraConfig =
      {
        github.user = "zmre";
        color.ui = true;
        pull.rebase = true;
        merge.conflictstyle = "diff3";
        init.defaultBranch = "main";
        http.sslVerify = true;
        commit.verbose = true;
        credential.helper =
          if pkgs.stdenvNoCC.isDarwin
          then "osxkeychain"
          else "cache --timeout=10000000";
        diff.algorithm = "patience";
        protocol.version = "2";
        core.commitGraph = true;
        gc.writeCommitGraph = true;
        push.autoSetupRemote = true;
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        # these should speed up vim nvim-tree and other things that watch git repos but
        # only works on mac. see https://github.com/nvim-tree/nvim-tree.lua/wiki/Troubleshooting#git-fsmonitor-daemon
        core.fsmonitor = true;
        core.untrackedcache = true;
      };
    # Really nice looking diffs
    delta = {
      enable = false;
      options = {
        syntax-theme = "Monokai Extended";
        line-numbers = true;
        navigate = true;
        side-by-side = true;
      };
    };
    # intelligent diffs that are syntax parse tree aware per language
    difftastic = {
      enable = true;
      background = "dark";
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
    browser =
      if pkgs.stdenvNoCC.isDarwin
      then "open"
      else "${pkgs.xdg-utils}/bin/xdg-open";
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
        tags = ["security"];
        title = "Cyberscoop";
        url = "https://www.cyberscoop.com/feed/";
      }
      {
        tags = ["security"];
        title = "Krebs on Security";
        url = "https://krebsonsecurity.com/feed/";
      }
      {
        tags = ["security"];
        title = "DefenseOne";
        url = "http://www.defenseone.com/rss/technology/ ";
      }
      {
        tags = ["news"];
        title = "NPR";
        url = "http://www.npr.org/rss/rss.php?id=1001";
      }
      {
        tags = ["news"];
        title = "Reuters Domestic";
        url = "http://feeds.reuters.com/Reuters/domesticNews";
      }
      {
        tags = ["startup"];
        title = "TechCrunch";
        url = "https://techcrunch.com/feed/";
      }
      {
        tags = ["tech"];
        title = "Reuters Tech";
        url = "http://feeds.reuters.com/reuters/technologyNews?format=xml";
      }
      {
        tags = ["tech"];
        title = "EFF";
        url = "http://www.eff.org/rss/updates.xml";
      }
    ];
  };

  # 2022-11-06 going to try kitty for a bit
  programs.kitty = {
    enable = true;
    keybindings = {
      "super+equal" = "increase_font_size";
      "super+minus" = "decrease_font_size";
      "super+0" = "restore_font_size";
      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";
      # cmd-[ and cmd-] switch tmux windows
      # \x02 is ctrl-b so sequence below is ctrl-b, h
      "cmd+[" = "send_text all \\x02h";
      "cmd+]" = "send_text all \\x02l";
      "ctrl+shift+h" = "neighboring_window left";
      "ctrl+shift+j" = "neighboring_window down";
      "ctrl+shift+k" = "neighboring_window up";
      "ctrl+shift+l" = "neighboring_window right";
    };
    font = {
      name = "Hasklug Nerd Font Mono Medium";
      #name = "Hasklug Nerd Font Medium"; # regular is too thin
      #name = "Inconsolata Nerd Font"; # no italic
      #name = "SpaceMono Nerd Font Mono";
      #name = "VictorMono Nerd Font";
      #name = "FiraCode Nerd Font"; # missing italic
      size =
        if pkgs.stdenvNoCC.isDarwin
        then 17
        else 12;
    };
    darwinLaunchOptions = ["--single-instance"];
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      macos_option_as_alt = "both";
      macos_quit_when_last_window_closed = true;
      adjust_line_height = "105%";
      disable_ligatures = "cursor"; # disable ligatures when cursor is on them
      shell_integration = "enabled";

      # Fonts
      bold_font = "Hasklug Nerd Font Mono Bold"; # "auto";
      italic_font = "Hasklug Nerd Font Mono Italic";
      bold_italic_font = "Hasklug Nerd Font Mono Bold Italic";

      # Window layout
      #hide_window_decorations = "titlebar-only";
      window_padding_width = "5";
      macos_show_window_title_in = "window";

      # Tab bar
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_title_template = "{title}"; # "{index}: {title}";

      # Colors
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
      active_tab_foreground = "#ffffff";
      active_tab_background = "#2233ff";
      tab_activity_symbol = " ";

      # Misc
      # nvim true-zen kitty integration requires following two settings, but I've disabled due to bugs in true-zen
      # allow_remote_control = "socket-only";
      # listen_on = "unix:/tmp/kitty-sock";
      visual_bell_duration = "0.1";
      background_opacity = "0.95";
      startup_session = "~/.config/kitty/startup.session";
      shell = "${pkgs.zsh}/bin/zsh --login --interactive";
    };
    theme = "One Half Dark"; # or Dracula or OneDark see https://github.com/kovidgoyal/kitty-themes/tree/master/themes
    # extraConfig = "\n";
  };
  programs.alacritty = {
    enable = true;
    package =
      pkgs.alacritty; # switching to unstable so i get 0.11 with undercurl support
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
      font.size =
        if pkgs.stdenvNoCC.isDarwin
        then 16
        else 9;
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
