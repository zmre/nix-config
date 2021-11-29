with (import (fetchTarball
  "https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz") { });
mkShell {
  buildInputs = [
    # Exploitation
    exploitdb
    metasploit
    sqlmap
    # Recon
    avahi
    arp-scan
    dnsenum
    dnsrecon
    hping
    masscan
    nikto
    nmap
    nmap-graphical
    rustscan
    theharvester
    wireshark
    wireshark-cli
    zmap
    # Passwords
    hashcat
    hashcat-utils
    thc-hydra
    # Sniffing
    bettercap
    dsniff
    mitmproxy
    # Web
    burpsuite
    dirb
    gobuster
    wfuzz
    wpscan
    # wifi
    aircrack-ng
    gqrx
    kismet
    wifite2
    # rfid
    proxmark3
    # crypto / stego
    stegseek
    exif
    zsteg
  ];
}
