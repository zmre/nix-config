{ config, lib, pkgs, ... }: {
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
      hping
      masscan
      nikto
      onesixtyone
      nmap-graphical
      rustscan
      snmpcheck
      sslscan
      theharvester
      # wireshark moved to nixos config
      # pick one of wireshark or wireshark-cli
      wireshark
      #wireshark-cli
      #zmap # currently marked broken 2022-01-31

      # Passwords
      fcrackzip
      john
      hashcat-utils
      pdfcrack
      rarcrack
      crunch # wordlist generator
      ncrack # network auth cracker

      # Sniffing
      ettercap
      bettercap
      mitmproxy
      wireshark
      ngrep
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
    ] ++ lib.optionals
    (!stdenv.isDarwin) [ # Things that only build on Linux go here
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
      afl # fuzzer tool

    ];
}
