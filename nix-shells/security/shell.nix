{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = [
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
    fierce
    fping
    hping
    masscan
    nikto
    onesixtyone
    p0f
    nmap
    nmap-graphical
    rustscan
    snmpcheck
    sslscan
    tcpflow
    theharvester
    wireshark
    wireshark-cli
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
    exif
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
