{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      # Exploitation
      exploitdb
      sqlmap
      arpoison

      # Recon
      avahi
      arp-scan
      arping
      dnsenum
      dnsrecon
      fierce # dns recon
      httrack # offline browser / website mirror
      fping
      boofuzz
      hping
      masscan
      nikto
      onesixtyone
      nmap # -graphical
      rustscan
      snmpcheck
      sslscan
      #theharvester # temp disable; broken 2024-09-06
      socialscan
      urlhunter
      cloudbrute
      #sn0int # temp disable cuz rust build issue 2024-08-26
      sslsplit
      # wireshark moved to nixos config
      # pick one of wireshark or wireshark-cli
      pkgs.stable.wireshark
      #wireshark-cli

      # Passwords
      fcrackzip
      john
      hashcat-utils
      pdfcrack
      rarcrack
      crunch # wordlist generator
      #chntpw
      #crowbar # build issues on 2024-10-30

      # Sniffing
      ettercap
      #bettercap # build issues on 2024-10-30
      proxify
      wireshark
      ngrep
      dnstop
      nload
      #netsniff-ng ?

      # Web
      dirb
      gobuster
      #wfuzz
      urlhunter

      # Crypto / stego
      #exif # installed elsewhere
      zsteg

      # Manipulation
      gdb
      radare2
      sqlitebrowser
      unrar
      netcat
      pwncat # netcat on steroids
      capstone # cstool disassembly tool
      binwalk

      # misc
      faraday-cli
      corkscrew # tunnel ssh through http proxies
      pwntools
    ]
    ++ lib.optionals
    (!pkgs.stdenv.isDarwin) [
      # Things that only build on Linux go here
      # Exploitation
      metasploit

      # Recon
      recon-ng
      enum4linux-ng # local privesc finder
      ike-scan
      pktgen
      ostinato
      #zmap # currently marked broken 2022-01-31

      # Passwords
      hashcat
      thc-hydra
      hcxtools
      ncrack # network auth cracker
      brutespray

      # Sniffing
      dsniff
      tcpflow
      p0f
      netsniff-ng
      mitmproxy
      dhcpdump
      proxychains

      # Web
      burpsuite
      zap
      wpscan

      # Wifi
      kismet
      wifite2
      reaverwps
      aircrack-ng

      # Bluetooth
      bluez
      # rfid
      proxmark3
      gnuradio
      gqrx
      hackrf
      ubertooth
      multimon-ng

      # Crypto / stego
      pngcheck
      stegseek

      # Manipulation
      radare2-cutter
      #afl # fuzzer tool
      # cloud
      cloud-nuke
      cloudfox
      ec2stepshell
      gato
      gcp-scanner
      #ggshield
      goblob
      imdshift
      pacu
      poutine
      #prowler
      yatas
      # git
      bomber-go
      cargo-audit
      credential-detector
      deepsecrets
      detect-secrets
      freeze
      git-secret
      gitjacker
      gitleaks
      gitls
      gokart
      legitify
      secretscanner
      skjold
      tell-me-your-secrets
      trufflehog
      whispers
      xeol

      # Misc
      keedump
      sploitscan
    ];
}
