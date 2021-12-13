# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./framework-hardware.nix
  ];

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "mem_sleep_default=deep" "net.ifnames=0" ];
    initrd.checkJournalingFS = false;
    supportedFilesystems = [ "btrfs" ];
    cleanTmpDir = true;
    tmpOnTmpfs = true;
  };

  system = {
    # It was trying to upgrade on wake from sleep and sometimes failed in the background
    # because the wifi wasn't up yet, then left my system in a weird state without a
    # current per-user profile in place. So for now, I'll upgrade deliberately.
    # Also, I'm using flakes now, so different system
    autoUpgrade.enable = false;
    #autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
    # this captures initial version. don't change it.
    stateVersion = "21.05"; # Did you read the comment?
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
    #cpuFreqGovernor = lib.mkDefault "ondemand";
  };

  networking = {
    hostName = "volantis";
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    wireless.interfaces = [ "wlan0" ];
    wireless.iwd.enable = true;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      packages = with pkgs; [ networkmanagerapplet ];
    };
    # The global useDHCP flag is deprecated, set to false here.
    useDHCP = false;
    interfaces.wlan0.useDHCP = true;
    firewall.enable = true;
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
  };

  hardware = {
    enableAllFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        mesa_drivers
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };
    pulseaudio = {
      enable = false;
      #package = pkgs.pulseaudioFull; # needed for bluetooth audio
    };
    # no bluetooth on boot
    bluetooth.enable = true;
    bluetooth.powerOnBoot = false;
  };
  sound.enable = true;
  security.rtkit.enable = true; # bring in audio

  # pipewire brings better audio/video handling
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Denver";
  services.timesyncd.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;
    useSandbox = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
    buildCores = 0; # use all available cores for building
  };
  nixpkgs.config = {
    allowUnfree = true;
    experimental-features = "nix-command flakes";
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball
        "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
    };
  };

  users.users.zmre = {
    isNormalUser = true;
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
    ];
  };
  security.sudo.enable = true;
  security.sudo.execWheelOnly = true;
  security.sudo.extraConfig = ''
    Defaults   timestamp_timeout=-1 
  '';
  # Allow fingerprint use by root and zmre
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
      if (action.id == "net.reactivated.fprint.device.enroll") {
        return subject.user == "zmre" || subject.user == "root" ? polkit.Result.YES : polkit.Result.NO
      }
    })
  '';
  # KeePassXC replaces this... I think
  security.pam.services.lightdm.enableGnomeKeyring = false;

  services.locate = {
    enable = true; # periodically update locate db
    localuser = null;
    locate = pkgs.mlocate;
  };
  services.printing.enable = true; # cupsd printing
  services.earlyoom.enable = true; # out of memory detection
  services.thermald.enable = true; # enable thermal data
  services.fprintd.enable = true; # enable fingerprint scanner
  services.autorandr.enable = true; # autodetect display config

  #services.touchegg.enable = true; # multi-touch gestures

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    autoPrune.dates = "weekly";
    # Don't start on boot; but it will start on-demand
    enableOnBoot = false;
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # TODO: does KeePassXC replace this, too?
  programs.ssh.startAgent = true;
  programs.dconf.enable = true;
  # Used to adjust the brightness of the screen
  programs.light.enable = true;
  programs.zsh.enable = true;
  programs.command-not-found.enable = true; # suggest install if cmd missing

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

  environment.systemPackages = with pkgs; [
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
  ];
  environment.sessionVariables = {
    LANGUAGE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
  environment.pathsToLink = [ "/libexec" ];

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
      package = pkgs.i3-gaps; # adds extra functionality
      extraPackages = with pkgs; [
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
