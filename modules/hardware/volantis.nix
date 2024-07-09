{
  config,
  pkgs,
  lib,
  ...
}: {
  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["mem_sleep_default=deep" "nvme.noacpi=1" "net.ifnames=0"];
    initrd.checkJournalingFS = false;
    supportedFilesystems = ["btrfs"];
    tmp.cleanOnBoot = true;
    tmp.useTmpfs = true;
  };

  environment.sessionVariables = {
    GDK_DPI_SCALE = "1.5";
    QT_SCALE_FACTOR = "1.5";
  };

  system = {
    # It was trying to upgrade on wake from sleep and sometimes failed in the background
    # because the wifi wasn't up yet, then left my system in a weird state without a
    # current per-user profile in place. So for now, I'll upgrade deliberately.
    # Also, I'm using flakes now, so different system
    autoUpgrade.enable = false;
  };

  # Leaving this here, but since enabling, lots of power drain when the laptop is sleeping
  #systemd.sleep.extraConfig = ''
  #AllowSuspendThenHibernate=yes
  #'';

  powerManagement = {
    enable = true;
    #powertop.enable = true;
  };
  # an alternative to above? is this needed?
  services = {
    #auto-cpufreq.enable = true;
    fwupd = {
      enable = true; # firmware update; run: sudo fwupdmgr update
      extraRemotes = ["lvfs-testing"];
      # Might be necessary once to make the update succeed
      uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = true;
    };
    # Quick suspend if power button pushed
    #logind.extraConfig = ''
    #HandlePowerKey=suspend
    #'';
  };

  networking = {
    hostName = "volantis";
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    wireless.interfaces = ["wlan0"];
    wireless.iwd.enable = true;
    networkmanager = {
      enable = false;
      wifi.backend = "iwd";
      # getting error: ‘network-manager-applet-1.24.0’, is not a NetworkManager plug-in. Those need to have a ‘networkManagerPlugin’ attribute.
      # just commenting for now 2022-05-30
      #packages = with pkgs.stable; [ networkmanagerapplet ];
      # don't use dhcp dns... use settings below instead
      dns = "none";
    };
    # The global useDHCP flag is deprecated, set to false here.
    useDHCP = false;
    interfaces.wlan0.useDHCP = true;

    # no longer using local dns -- tailscale settings will take
    # over automatically and make sure all dns is safe
    nameservers = ["1.1.1.1" "8.8.8.8"];
    resolvconf.useLocalResolver = false;
    firewall.enable = true;
    firewall.checkReversePath = false; # disable rpfilter so wireguard works
    # Note: wireguard setup is not currently reproducible and uses network manager
    # doing this to avoid putting anything sensitive in here, but should revisit
    # after working on reproducible secrets stuff. TODO.
    # firewall.allowedTCPPorts = [ ... ];
    #firewall.allowedUDPPorts = [ ];
  };

  services.tailscale.enable =
    true; # p2p mesh vpn with my hosts -- does it override dnscrypt-proxy?
  services.dnscrypt-proxy2 = {
    enable = false;
    settings = {
      listen_addresses = ["127.0.0.1:53"];
      ipv4_servers = true;
      ipv6_servers = false;
      require_dnssec = true;
      doh_servers = true;
      odoh_servers = true;
      require_nolog = true;
      bootstrap_resolvers = ["9.9.9.9:53" "8.8.8.8:53"];
      cache = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      server_names = [
        "cloudflare-security"
        #"cloudflare-security-ipv6"
        #"doh-crypto-sx"
      ];
    };
  };

  hardware = {
    enableAllFirmware = true;
    # video.hidpi.enable = true;
    cpu.intel.updateMicrocode = true;
    # graphics = {
    #   enable = true;
    #   # driSupport = true;
    #   # driSupport32Bit = true;
    #   extraPackages = with pkgs; [
    #     # mesa.drivers
    #     # vaapiVdpau
    #     vaapiIntel
    #     libvdpau-va-gl
    #     intel-media-driver
    #   ];
    # };
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
  services.blueman.enable = true;
  #services.xserver.dpi = 160; # fix font sizes in x
  #services.xserver.upscaleDefaultCursor = true; # make cursor bigger; requires dpi be set

  # pipewire brings better audio/video handling
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  services.fprintd.enable = true; # enable fingerprint scanner
  # Allow fingerprint use by root and zmre
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
      if (action.id == "net.reactivated.fprint.device.enroll") {
        return subject.user == "zmre" || subject.user == "root" ? polkit.Result.YES : polkit.Result.NO
      }
    })
  '';

  services.cachix-agent.enable = false;

  #services.touchegg.enable = true; # multi-touch gestures

  #virtualisation.docker.rootless.enable = true;
  #virtualisation.docker.rootless.setSocketVariable = true;
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    autoPrune.dates = "weekly";
    # Don't start on boot; but it will start on-demand
    enableOnBoot = false;
  };

  virtualisation.libvirtd = {
    enable = true;
    onBoot = "start";
    qemu.package = pkgs.qemu_kvm;
  };
}
