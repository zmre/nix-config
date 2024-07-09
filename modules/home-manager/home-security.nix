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
      metasploit
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
      pktgen
      boofuzz
      ostinato
      hping
      masscan
      nikto
      onesixtyone
      nmap # -graphical
      rustscan
      snmpcheck
      sslscan
      theharvester
      socialscan
      urlhunter
      sn0int
      zmap
      cloudbrute
      sn0int
      sslsplit
      # wireshark moved to nixos config
      # pick one of wireshark or wireshark-cli
      wireshark
      #wireshark-cli
      zmap # currently marked broken 2022-01-31

      # Passwords
      fcrackzip
      john
      hashcat-utils
      pdfcrack
      rarcrack
      crunch # wordlist generator
      ncrack # network auth cracker
      brutespray
      #chntpw
      crowbar
      hcxtools

      # Sniffing
      ettercap
      bettercap
      mitmproxy
      proxychains
      proxify
      wireshark
      ngrep
      dhcpdump
      dnstop
      nload
      #netsniff-ng ?

      # Web
      dirb
      gobuster
      wfuzz
      wpscan
      urlhunter

      # crypto / stego
      #exif # installed elsewhere
      zsteg

      # manipulation
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
      # Recon
      enum4linux-ng # local privesc finder
      ike-scan
      # Passwords
      hashcat
      thc-hydra
      # Sniffing
      dsniff
      tcpflow
      p0f
      netsniff-ng
      # Web
      burpsuite
      zap
      # Wifi
      kismet
      wifite2
      reaverwps
      aircrack-ng
      # bluetooth
      bluez
      # rfid
      proxmark3
      gnuradio
      gqrx
      hackrf
      multimon-ng
      # crypto / stego
      pngcheck
      stegseek
      # manipulation
      radare2-cutter
      #afl # fuzzer tool
      # cloud
      cloud-nuke
      cloudfox
      ec2stepshell
      gato
      gcp-scanner
      ggshield
      goblob
      imdshift
      pacu
      poutine
      prowler
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
      # misc
      keedump
      sploitscan
    ];
}
