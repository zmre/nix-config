# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
    autoUpgrade.enable = true;
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
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.extraPackages = with pkgs; [
      mesa_drivers
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
    enableAllFirmware = true;
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull; # needed for bluetooth audio
    };
    # no bluetooth on boot
    bluetooth.enable = true;
    bluetooth.powerOnBoot = false;
  };
  sound.enable = true;
  security.rtkit.enable = true; # bring in audio

  # Set your time zone.
  time.timeZone = "America/Denver";
  services.timesyncd.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  nix = {
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
      "libvirtd"
      "lxd"
      "render"
      "networkmanager"
    ];
  };
  security.sudo.enable = true;
  security.sudo.execWheelOnly = true;
  security.sudo.extraConfig = ''
    Defaults   timestamp_timeout=-1 
  '';
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
      if (action.id == "net.reactivated.fprint.device.enroll") {
        return subject.user == "zmre" || subject.user == "root" ? polkit.Result.YES : polkit.Result.NO
      }
    })
  '';
  security.pam.services.lightdm.enableGnomeKeyring = true;

  services.locate.enable = true; # periodically update locate db
  services.printing.enable = true; # cupsd printing
  services.earlyoom.enable = true; # out of memory detection
  services.thermald.enable = true; # enable thermal data
  services.fprintd.enable = true; # enable fingerprint scanner

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  programs.ssh.startAgent = true;
  programs.dconf.enable = true;
  # Used to adjust the brightness of the screen
  programs.light.enable = true;
  programs.zsh.enable = true;
  programs.command-not-found.enable = true; # suggest install if cmd missing

  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [ powerline-fonts source-code-pro nerdfonts vegur ];
    fontconfig.defaultFonts = {
      monospace = [ "MesloLGS Nerd Font Mono" ];
      sansSerif = [ "MesloLGS Nerd Font" ];
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    binutils
    coreutils
    usbutils
    dnsutils
    compsize # btrfs util
    x11_ssh_askpass
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
    layout = "us";
    # Enable touchpad support
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
      touchpad.middleEmulation = true;
      touchpad.tapping = true;
      touchpad.scrollMethod = "twofinger";
      #touchpad.disableWhileTyping = true;
    };
    # pipewire brings better audio/video handling
    #pipewire = {
    #enable = true;
    #alsa = {
    #enable = true;
    #support32Bit = true;
    #};
    #pulse.enable = true;
    #};
    #gnome3.gnome-keyring.enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps; # adds extra functionality
      extraPackages = with pkgs; [
        rofi
        polybar
        feh
        lxappearance
        xclip
        i3status-rust
        i3lock
        i3blocks
      ];
    };
  };
}
