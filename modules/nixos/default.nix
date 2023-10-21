{
  config,
  username,
  pkgs,
  stable,
  ...
}: {
  # bundles essential nixos modules
  imports = [../common.nix];

  # Note: these vars are pam environment so set on login globally
  # as part of parent to shells. Starting new shells doesn't get the
  # new env. You have to logout first. Or use home-manager vars instead.
  environment.sessionVariables = {
    LANGUAGE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
  environment.systemPackages = with pkgs.stable; [
    vim
    wget
    curl
    git
    binutils
    pciutils
    coreutils
    psmisc
    usbutils
    dnsutils
    libva-utils
    compsize # btrfs util
    x11_ssh_askpass
    veracrypt
    firmware-manager
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  # nixpkgs.config = import ../../config.nix;

  services.locate = {
    enable = true; # periodically update locate db
    localuser = null;
    package = pkgs.mlocate;
  };
  #services.timesyncd.enable = true;
  services.printing.enable = true; # cupsd printing
  services.earlyoom.enable = true; # out of memory detection
  # services.thermald.enable = true; # enable thermal data
  services.autorandr.enable = true; # autodetect display config
  security.sudo.enable = true;
  security.sudo.execWheelOnly = true;
  security.sudo.extraConfig = ''
    Defaults   timestamp_timeout=-1
  '';
  # suggest install package if cmd missing
  programs.command-not-found.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      "${username}" = {
        isNormalUser = true;
        createHome = true;
        useDefaultShell = true;
        extraGroups = [
          "wheel" # Enable ‘sudo’ for the user.
          "video"
          "render"
          "libvirtd"
          "power"
          "lxd"
          "render"
          "networkmanager"
          "docker"
          "wireshark"
        ];
        #hashedPassword = "generate with: mkpasswd -m sha-512";
      };
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  programs.ssh.startAgent = true;
  programs.dconf.enable = true;
  # Used to adjust the brightness of the screen
  programs.light.enable = true;
  # clight requires a latitude and longitude
  location.latitude = 38.0;
  location.longitude = -105.0;
  # Used to automatically adjust brightness and temperature of the screen
  #services.clight.enable = true;

  system.stateVersion = "21.11";

  fonts = {
    enableDefaultPackages = true;
    fontconfig.enable = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      powerline-fonts
      source-code-pro
      (nerdfonts.override {
        # holy hell it can take a long time to install everything; strip down
        fonts = [
          "FiraCode"
          "Hasklig"
          "DroidSansMono"
          "DejaVuSansMono"
          "iA-Writer"
          "JetBrainsMono"
          "Meslo"
          "SourceCodePro"
          "Inconsolata"
          "NerdFontsSymbolsOnly" # for some apps, you can use this and then any unpatched font
        ];
      })
      vegur
      noto-fonts
    ];
    fontconfig.defaultFonts = {
      monospace = ["MesloLGS Nerd Font Mono" "Noto Mono"];
      sansSerif = ["MesloLGS Nerd Font" "Noto Sans"];
      serif = ["Noto Serif"];
    };
  };

  # needed here instead of home-manager so we can run as a user and not root
  programs.wireshark.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;
    defaultDepth = 24;
    xkbOptions = "caps:escape";
    # Setup a graphical login
    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+i3";
      sessionCommands = ''
        case $(hostname) in
          volantis)
            ${pkgs.xorg.xrandr}/bin/xrandr --newmode "3000x2000_60.00"  513.44  3000 3240 3568 4136  2000 2001 2004 2069  -HSync +Vsync
            ${pkgs.xorg.xrandr}/bin/xrandr --addmode eDP-1 "3000x2000_60.00"
            ${pkgs.xorg.xrandr}/bin/xrandr -s 3000x2000
            ;;
          *)
            echo unknown host
            ;;
        esac
      '';
    };
    # Keyboard
    layout = "us";
    autoRepeatDelay = 265;
    autoRepeatInterval = 20;
    # Enable touchpad support
    libinput = {
      enable = true;
      touchpad.accelSpeed = "0.7";
      touchpad.naturalScrolling = true;
      touchpad.middleEmulation = true;
      touchpad.tapping = true;
      touchpad.scrollMethod = "twofinger";
      #touchpad.disableWhileTyping = true;
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.stable.i3-gaps; # adds extra functionality
      extraPackages = with pkgs.stable; [
        rofi
        polybar
        feh
        lxappearance
        xclip
        picom
        i3status-rust
        i3lock
        i3blocks
      ];
    };
  };
}
