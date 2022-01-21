{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    # Exploitation
    exploitdb
    metasploit
    sqlmap
    # Recon
    avahi
    arp-scan
    arping
    dnsenum
    dnsrecon
    enum4linux-ng
    fierce
    fping
    hping
    masscan
    nikto
    onesixtyone
    p0f
    # pick one of nmap or nmap-graphical
    #nmap
    nmap-graphical
    rustscan
    snmpcheck
    sslscan
    tcpflow
    theharvester
    # wireshark moved to nixos config
    # pick one of wireshark or wireshark-cli
    wireshark
    #wireshark-cli
    zmap
    # Passwords
    fcrackzip
    john
    hashcat
    hashcat-utils
    pdfcrack
    rarcrack
    thc-hydra
    # Sniffing
    ettercap
    bettercap
    dsniff
    mitmproxy
    # Web
    burpsuite
    dirb
    gobuster
    wfuzz
    wpscan
    zap
    # wifi
    aircrack-ng
    gqrx
    kismet
    wifite2
    reaverwps
    # bluetooth
    bluez
    # rfid
    proxmark3
    gnuradio
    gqrx
    hackrf
    multimon-ng
    # crypto / stego
    stegseek
    # installed elsewhere
    #exif
    zsteg
    # manipulation
    gdb
    radare2
    radare2-cutter
    sqlitebrowser
    unrar
    netcat
    ngrep
    # misc
    faraday-cli

  ];
}
