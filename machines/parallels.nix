# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./parallels-hardware.nix
  ];

  # Use the GRUB 2 boot loader.
  boot = {
    loader.grub.enable = true;
    loader.grub.version = 2;
    loader.grub.efiSupport = true;
    loader.grub.efiInstallAsRemovable = true;
    loader.efi.canTouchEfiVariables = false;
    loader.efi.efiSysMountPoint = "/boot";
    # Define on which hard drive you want to install Grub.
    loader.grub.device = "nodev"; # or "nodev" for efi only
    loader.systemd-boot.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.checkJournalingFS = false;
    supportedFilesystems = [ "btrfs" ];
  };

  networking.hostName = "nixos-pw-vm"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.interfaces.enp0s5.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.enableAllFirmware = true;
  # broken...
  #hardware.parallels.enable = true;

  system = {
    autoUpgrade.enable = true;
    autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
    # this captures initial version. don't change it.
    stateVersion = "21.05"; # Did you read the comment?
  };

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

  # Set your time zone.
  time.timeZone = "America/Denver";
  services.timesyncd.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #font = "MesloLGS Nerd Font Mono";
    keyMap = "us";
  };

  environment.pathsToLink = [ "/libexec" ];

  programs.ssh.startAgent = true;
  programs.dconf.enable = true;
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

  services.locate.enable = true; # periodically update locate db
  services.earlyoom.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;
    xkbOptions = "caps:escape";
    #desktopManager.xterm.enable = true;
    displayManager.defaultSession = "none+i3";
    # Setup a graphical login
    displayManager.lightdm.enable = true;
    layout = "us";
    libinput.enable = true;
    libinput.touchpad.disableWhileTyping = true;
    #windowManager.xmonad = {
    #enable = true;
    #enableContribAndExtras = true;
    #extraPackages = with pkgs; [
    #
    #];
    #};
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

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull; # needed for bluetooth audio
  };
  # no bluetooth on boot
  hardware.bluetooth.enable = false;
  hardware.bluetooth.powerOnBoot = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zmre = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
    ];
  };
  security.sudo.enable = true;
  security.sudo.execWheelOnly = true;
  security.sudo.extraConfig = ''
    Defaults   timestamp_timeout=-1 
  '';

  #virtualization.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    binutils
    coreutils
    dnsutils
    compsize # btrfs util
    x11_ssh_askpass
  ];

  environment.sessionVariables = {
    LANGUAGE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  programs.mtr.enable = true;
  #programs.gnupg.agent = {
  #enable = true;
  #enableSSHSupport = true;
  #};

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

}
