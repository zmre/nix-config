{pkgs ? import <nixpkgs> {}}:
with pkgs;
  mkShell {
    # TODO: unify this with home-security.nix instead of duplicating
    buildInputs =
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
        fierce
        httrack # offline browser / website mirror
        fping
        hping
        masscan
        nikto
        onesixtyone
        #nmap-graphical
        nmap
        rustscan
        snmpcheck
        sslscan
        theharvester
        #zmap # currently marked broken 2022-01-31
        #cloudbrute
        #sn0int
        #sslsplit

        # Passwords
        fcrackzip
        john
        hashcat-utils
        pdfcrack
        rarcrack
        crunch # wordlist generator
        ncrack # network auth cracker
        #brutespray
        #chntpw
        #crowbar
        #hcxtools

        # Sniffing
        ettercap
        bettercap
        mitmproxy
        # wireshark moved below as it only builds on linux 2022-03-30
        ngrep

        # Web
        dirb
        feroxbuster
        gobuster
        wfuzz
        wpscan
        urlhunter

        # crypto / stego
        #exif # installed elsewhere
        zsteg

        # manipulation
        radare2
        sqlitebrowser
        unrar
        netcat
        pwncat # netcat on steroids
        capstone # cstool disassembly tool
        #ddrescue
        #ext4magic
        #extundelete
        #volatility
        #elfutils
        #jd
        #jd-gui
        #patchelf
        #retdec
        #snowman
        #valgrind
        binwalk

        # misc
        faraday-cli
        corkscrew # tunnel ssh through http proxies
        pwntools
      ]
      ++ lib.optionals (!pkgs.stdenv.isAarch64) [
        # x86 only
        ghidra-bin # NSA's free ida-pro, basically
        gdb
      ]
      ++ lib.optionals (!stdenv.isDarwin) [
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
        # wireshark moved to nixos config
        # pick one of wireshark or wireshark-cli
        wireshark
        #wireshark-cli
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
      ];
  }
