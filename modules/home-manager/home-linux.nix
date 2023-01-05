{ config, lib, pkgs, ... }:
let
  browser = [ "org.qutebrowser.qutebrowser.desktop" ];
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
  home.packages = with pkgs.stable; [
    # wm support
    xss-lock
    syncthingtray-minimal
    arandr
    #i3-auto-layout # should change default split; not working

    # apps
    keepassxc
    spotify-qt
    slack
    discord
    nomacs

    # terminal linux-only apps
    ueberzug # for terminal image previews
    ytfzf # terminal youtube search/launch
    djvulibre

    chkrootkit # scan for breaches

    traceroute
  ];
  gtk = {
    enable = true;

    font = {
      name = "FiraCode Nerd Font";
      size = 9;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      #name = "Breeze Dark";
      #package = pkgs.gnome-breeze;
    };
    theme = {
      package = pkgs.matcha-gtk-theme;
      name = "Matcha-dark-azul";
    };
  };
  xdg.mimeApps.enable = true;
  xdg.mimeApps.associations.added = associations;
  xdg.mimeApps.defaultApplications = associations;

  services.udiskie = {
    enable = true; # automount disks
    automount = true;
    notify = true;
    tray = "auto";
  };

  # Need to set this up per device... just install it and let config be manual
  services.syncthing = {
    enable = true;
    tray.enable = false;
  };

  services.dunst.enable = true; # notification daemon
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
      names = [ "pango:SauceCodePro Nerd Font" ];
      size = 6.0;
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
      "${mod}+t" = "layout tabbed";
      "${mod}+s" = "layout stacking";
      "${mod}+w" = "layout default";
      "${mod}+e" = "layout toggle split tabbed stacking splitv splith";
      "${mod}+m" = "move scratchpad";
      "${mod}+o" = "scratchpad show";
      "${mod}+p" = "floating toggle";
      "${mod}+Shift+p" = ''[class="KeePassXC"] scratchpad show'';
      "${mod}+x" = "move workspace to output next";
      "${mod}+Ctrl+Right" = "workspace next";
      "${mod}+Ctrl+Left" = "workspace prev";
      "${mod}+F9" = "exec i3lock --nofork -i ~/.lockpaper.png";
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
      {
        command = "blueman-tray";
        always = true;
        notification = false;
      }
      { command = "qutebrowser"; }
      { command = "alacritty"; }
      {
        command = "keepassxc";
        always = true;
      }
    ];
  };
  # xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
  # screen before suspend. Use loginctl lock-session to lock your screen.
  xsession.windowManager.i3.extraConfig = ''
    default_orientation auto
    exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork -i ~/.lockpaper.png
    exec_always --no-startup-id i3-auto-layout
    for_window [title="Chooser"] floating enable
    for_window [class="KeePassXC"] move scratchpad
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

  # programs.mpv = {
  #   enable = true;
  #   scripts = with pkgs.mpvScripts; [ thumbnail sponsorblock ];
  #   config = {
  #     # disable on-screen controller -- else I get a message saying I have to add this
  #     osc = false;
  #     # Use a large seekable RAM cache even for local input.
  #     cache = true;
  #     save-position-on-quit = false;
  #     x11-bypass-compositor = true;
  #     #ytdl-format = "bestvideo+bestaudio";
  #     # have mpv use yt-dlp instead of youtube-dl
  #     script-opts-append = "ytdl_hook-ytdl_path=${pkgs.yt-dlp}/bin/yt-dlp";
  #   };
  #   defaultProfiles = [ "gpu-hq" ];
  # };

  # Backup browser for when Qutebrowser doesn't work as expected
  # currently fails to compile on darwin
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

  # currently fails to compile on darwin
  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = false;
    keyBindings = {
      normal = {
        ",m" = "spawn mpv {url}";
        ",M" = ''hint links spawn mpv "{hint-url}"'';
        ",d" = ''spawn yt-dlp -o "~/Downloads/%(title)s.%(ext)s" "{url}"'';
        ",D" = ''
          hint links spawn yt-dlp -o "~/Downloads/%(title)s.%(ext)s" "{url}"'';
        ",f" = ''spawn firefox "{url}"'';
        # get current page as markdown link
        ",ym" = "yank inline [{title}]({url:pretty})";
        "xt" = "config-cycle tabs.show always never";
        "<f12>" = "inspector";
        # search for link with / then hit enter to follow
        "<return>" = "selection-follow";
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
      # StevenBlack list pulls from lots of sources; we also update our /etc/hosts
      # with this, but that only gets an update when we rebuild our nix system
      # whereas this should reload more often
      content.blocking.hosts.lists = [
        "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2022.txt"
      ];
      content.blocking.whitelist = [ "https://*.reddit.com/*" ];

      content.default_encoding = "utf-8";
      content.geolocation = false;
      content.cookies.accept = "no-3rdparty";
      qt.highdpi = true;
      # might break some sites; stops fingerprinting
      content.canvas_reading = false;
      content.webrtc_ip_handling_policy = "default-public-interface-only";
      content.javascript.can_access_clipboard = true;
      content.site_specific_quirks.enabled = false;
      content.headers.user_agent =
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36";
      content.pdfjs = true;
      content.autoplay = false;
      # Disable smooth scrolling on mac because of https://github.com/qutebrowser/qutebrowser/issues/6840
      scrolling.smooth = if pkgs.stdenv.isDarwin then false else true;
      auto_save.session = true; # remember open tabs
      session.lazy_restore = true;
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
      # enabling darkmode auto-changes website colors and images and often makes things worse instead of better :-(
      colors.webpage.darkmode.enabled = false;
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
      po = "https://getpocket.com/my-list";
    };
    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?q={}&ia=web";
      d = "https://duckduckgo.com/?q={}&ia=web";
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      aw = "https://wiki.archlinux.org/?search={}";
      nw = "https://nixos.wiki/index.php?search={}";
      np =
        "https://search.nixos.org/packages?channel=22.11&from=0&size=100&sort=relevance&type=packages&query={}";
      nu =
        "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      no =
        "https://search.nixos.org/options?channel=22.11&from=0&size=50&sort=relevance&type=packages&query={}";
      nf =
        "https://search.nixos.org/flakes?channel=22.11&from=0&size=50&sort=relevance&type=packages&query={}";
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

}
