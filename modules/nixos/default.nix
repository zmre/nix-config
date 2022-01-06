{ config, pkgs, stable, ... }: {
  # bundles essential nixos modules
  imports = [ ../common.nix ];

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
    chkrootkit
    veracrypt
    firmware-manager
  ];

  services.locate = {
    enable = true; # periodically update locate db
    localuser = null;
    locate = pkgs.mlocate;
  };
  services.printing.enable = true; # cupsd printing
  services.earlyoom.enable = true; # out of memory detection
  services.thermald.enable = true; # enable thermal data
  services.autorandr.enable = true; # autodetect display config
  security.sudo.enable = true;
  security.sudo.execWheelOnly = true;
  security.sudo.extraConfig = ''
    Defaults   timestamp_timeout=-1 
  '';

  hm = { pkgs, ... }: { imports = [ ../home-manager/home-linux.nix ]; };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    #mutableUsers = false;
    users = {
      "${config.user.name}" = {
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
  services.clight.enable = true;

  system.stateVersion = "21.11";

  fonts = {
    enableDefaultFonts = true;
    fontconfig.enable = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      powerline-fonts
      source-code-pro
      nerdfonts
      vegur
      noto-fonts
    ];
    fontconfig.defaultFonts = {
      monospace = [ "MesloLGS Nerd Font Mono" "Noto Mono" ];
      sansSerif = [ "MesloLGS Nerd Font" "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;
    defaultDepth = 24;
    xkbOptions = "caps:escape";
    displayManager.defaultSession = "none+i3";
    # Setup a graphical login
    displayManager.lightdm.enable = true;
    # Keyboard
    layout = "us";
    autoRepeatDelay = 500;
    autoRepeatInterval = 50;
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
