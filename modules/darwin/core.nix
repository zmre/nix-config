{
  inputs,
  config,
  pkgs,
  ...
}: {
  # environment setup
  environment = {
    loginShell = pkgs.zsh;
    pathsToLink = ["/Applications"];
    # I exclusively control homebrew from here, but it's annoying to fully qualify the path to brew binaries
    systemPath = ["/opt/homebrew/bin" "/opt/homebrew/sbin"];
    #backupFileExtension = "backup";
    etc = {
      darwin.source = "${inputs.darwin}";
      hosts.source = "${inputs.sbhosts}/hosts";
    };
    # Use a custom configuration.nix location.
    # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix

    # packages installed in system profile
    systemPackages = with pkgs; [git curl coreutils gnused pam-reattach zoxide];

    # Fix "Too many open files" problems. Based on this:
    # https://medium.com/mindful-technology/too-many-open-files-limit-ulimit-on-mac-os-x-add0f1bfddde
    # Needs reboot to take effect
    # Changes default from 256 to 524,288 (probably a bigger jump than is really necessary)
    launchDaemons.ulimitMaxFiles = {
      enable = true;
      target = "limit.maxfiles"; # suffix .plist
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
                  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>Label</key>
            <string>limit.maxfiles</string>
            <key>ProgramArguments</key>
            <array>
              <string>launchctl</string>
              <string>limit</string>
              <string>maxfiles</string>
              <string>524288</string>
              <string>524288</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>ServiceIPC</key>
            <false/>
          </dict>
        </plist
      '';
    };
  };

  # Many of these taken from https://github.com/mathiasbynens/dotfiles/blob/master/.macos
  system = {
    activationScripts = {
      extraActivation = {
        enable = true;
        text = ''
          echo "Activating extra preferences..."
          # Close any open System Preferences panes, to prevent them from overriding
          # settings we’re about to change
          osascript -e 'tell application "System Preferences" to quit'

          # Show the ~/Library folder
          #chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

          # Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
          # defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

          # Display emails in threaded mode, sorted by date (newest at the top)
          defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
          defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "no"
          defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

          # Doesn't seem to matter in the global domain so trying this
          defaults write "/Library/Preferences/com.apple.SoftwareUpdate" ScheduleFrequency 1

          defaults write com.apple.spotlight orderedItems -array \
            '{"enabled" = 1;"name" = "APPLICATIONS";}' \
            '{"enabled" = 1;"name" = "DIRECTORIES";}' \
            '{"enabled" = 1;"name" = "PDF";}' \
            '{"enabled" = 1;"name" = "DOCUMENTS";}' \
            '{"enabled" = 1;"name" = "PRESENTATIONS";}' \
            '{"enabled" = 1;"name" = "SPREADSHEETS";}' \
            '{"enabled" = 1;"name" = "MENU_OTHER";}' \
            '{"enabled" = 1;"name" = "CONTACT";}' \
            '{"enabled" = 1;"name" = "IMAGES";}' \
            '{"enabled" = 1;"name" = "MESSAGES";}' \
            '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
            '{"enabled" = 1;"name" = "EVENT_TODO";}' \
            '{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
            '{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
            '{"enabled" = 0;"name" = "FONTS";}' \
            '{"enabled" = 0;"name" = "BOOKMARKS";}' \
            '{"enabled" = 0;"name" = "MUSIC";}' \
            '{"enabled" = 0;"name" = "MOVIES";}' \
            '{"enabled" = 0;"name" = "SOURCE";}' \
            '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
            '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
            '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

          echo "Turning on verbose boot startup"
          sudo nvram boot-args="-v"

          echo "Restoring system hotkeys and amethyst hotkeys"
          defaults import com.apple.symbolichotkeys ${./plists/symbolichotkeys.plist}
          defaults import com.amethyst.Amethyst ${./plists/amethyst.plist}
        '';
        # to create an importable plist, see export-plists.sh
      };
      postUserActivation.text = ''
        # Following line should allow us to avoid a logout/login cycle
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  launchd.user.agents.raycast = {
    serviceConfig.ProgramArguments = ["${pkgs.raycast}/Applications/Raycast.app/Contents/MacOS/Raycast"];
    serviceConfig.RunAtLoad = true;
  };

  documentation.enable = true; # temp disable 2024-07-06 to workaround issue
  # documentation.doc.enable = false;
  # documentation.man.enable = false;
  # documentation.man.generateCaches.enable = false;
  # documentation.nixos.enable = false;

  # Just configure DNS for WiFi for now
  networking.knownNetworkServices = ["Wi-Fi"];
  networking.dns = ["1.1.1.1" "1.0.0.1"];
  #networking.dns = [ "127.0.0.1" "1.1.1.1" ];
  # So the nextdns installed by nix is not signed and apple refuses to run it.
  # Switching to the version from the App store
  # services.nextdns = {
  #   enable = true;
  #   arguments = [ "-config" "f73bff" ];
  # };

  fonts.packages = with pkgs; [
    # powerline-fonts
    # source-code-pro
    roboto-slab
    source-sans-pro
    (nerdfonts.override {
      # holy hell it can take a long time to install everything; strip down
      fonts = [
        "FiraCode"
        "Hasklig"
        "DroidSansMono"
        "DejaVuSansMono"
        "iA-Writer"
        "JetBrainsMono"
        "Meslo"
        "SourceCodePro"
        "Inconsolata"
        "NerdFontsSymbolsOnly" # for some apps, you can use this with any unpatched font
      ];
    })
    montserrat
    raleway
    vegur
    noto-fonts
    vistafonts # needed for msoffice
  ];
  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}" "darwin=/etc/${config.environment.etc.darwin.target}"];
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  # auto manage nixbld users with nix darwin
  nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # allow touchid to auth sudo -- this comes from pam.nix, which needs to be loaded before this
  # it's now standard to nix-darwin, but without the special sauch needed for tmux, so we
  # will continue using our custom script
  security.pam.enableCustomSudoTouchIdAuth = true;
}
