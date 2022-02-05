# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
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
    # loader.systemd-boot.enable = true;
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

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.enableAllFirmware = true;
  # broken...
  #hardware.parallels.enable = true;

  system = {
    autoUpgrade.enable = false;
    # this captures initial version. don't change it.
    stateVersion = "21.11"; # Did you read the comment?
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

  # Set your time zone.
  time.timeZone = "America/Denver";
  services.timesyncd.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.pathsToLink = [ "/libexec" ];

  services.locate.enable = true; # periodically update locate db
  services.earlyoom.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;
    xkbOptions = "caps:escape";
    displayManager.defaultSession = "none+i3";
    # Setup a graphical login
    displayManager.lightdm.enable = true;
    layout = "us";
    libinput.enable = true;
    libinput.touchpad.disableWhileTyping = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull; # needed for bluetooth audio
  };
  # no bluetooth
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

  networking.firewall.enable = true;
}
