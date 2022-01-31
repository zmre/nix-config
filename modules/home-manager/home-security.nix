{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
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
    enum4linux-ng # local privesc finder
    fierce
    httrack # offline browser / website mirror
    fping
    hping
    ike-scan
    masscan
    nikto
    onesixtyone
    p0f
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
    crunch # wordlist generator
    ncrack # network auth cracker

    # Sniffing
    ettercap
    bettercap
    dsniff
    mitmproxy
    wireshark
    ngrep

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
    pwncat # netcat on steroids
    capstone # cstool disassembly tool
    afl # fuzzer tool
    binwalk

    # misc
    faraday-cli
    corkscrew # tunnel ssh through http proxies

  ];
}
