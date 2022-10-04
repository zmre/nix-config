{ inputs, config, pkgs, ... }:
let prefix = "/run/current-system/sw/bin";
in {
  # environment setup
  environment = {
    loginShell = pkgs.stable.zsh;
    pathsToLink = [ "/Applications" ];
    # I exclusively control homebrew from here, but it's annoying to fully qualify the path to brew binaries
    systemPath = [ "/opt/homebrew/bin" ];
    etc = { darwin.source = "${inputs.darwin}"; };

    # packages installed in system profile
    systemPackages = with pkgs; [ git curl coreutils gnused ];

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

    # Many of these taken from https://github.com/mathiasbynens/dotfiles/blob/master/.macos
    extraInit = ''
      # Close any open System Preferences panes, to prevent them from overriding
      # settings we’re about to change
      osascript -e 'tell application "System Preferences" to quit'

      defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false
      # Increase window resize speed for Cocoa applications
      defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
      # Automatically quit printer app once the print jobs complete
      defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
      # Require password immediately after sleep or screen saver begins
      defaults write com.apple.screensaver askForPassword -int 1
      defaults write com.apple.screensaver askForPasswordDelay -int 0
      # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
      defaults write com.apple.screencapture type -string "png"
      # Show icons for hard drives, servers, and removable media on the desktop
      defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
      defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
      defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
      defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
      # Finder: show status bar
      defaults write com.apple.finder ShowStatusBar -bool true
      # Finder: show path bar
      defaults write com.apple.finder ShowPathbar -bool true
      # Avoid creating .DS_Store files on network or USB volumes
      defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
      defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
      # Privacy: don’t send search queries to Apple
      defaults write com.apple.Safari UniversalSearchEnabled -bool false
      defaults write com.apple.Safari SuppressSearchSuggestions -bool true
      # Show the full URL in the address bar (note: this still hides the scheme)
      defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
      # Prevent Safari from opening ‘safe’ files automatically after downloading
      defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
      # Add a context menu item for showing the Web Inspector in web views
      defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
      # Enable continuous spellchecking
      defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
      # Disable auto-correct
      defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
      # Disable AutoFill
      defaults write com.apple.Safari AutoFillFromAddressBook -bool false
      defaults write com.apple.Safari AutoFillCreditCardData -bool false
      defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false
      # Warn about fraudulent websites
      defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
      # Disable Java
      defaults write com.apple.Safari WebKitJavaEnabled -bool false
      defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
      defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

      # Prevent Time Machine from prompting to use new hard drives as backup volume
      defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
      # Enable the automatic update check
      defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

      # Check for software updates daily, not just once per week
      defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

      # Install System data files & security updates
      defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
      # Turn on app auto-update
      defaults write com.apple.commerce AutoUpdate -bool true
      # Prevent Photos from opening automatically when devices are plugged in
      defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
    '';
  };

  # Just configure DNS for WiFi for now
  networking.knownNetworkServices = [ "Wi-Fi" ];
  networking.dns = [ "1.1.1.1" "1.0.0.1" ];

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  fonts.fontDir.enable =
    true; # if this is true, manually installed system fonts will be deleted!
  fonts.fonts = with pkgs.stable; [
    powerline-fonts
    source-code-pro
    nerdfonts
    vegur
    noto-fonts
    vistafonts # needed for msoffice
  ];
  nix.nixPath = [ "darwin=/etc/${config.environment.etc.darwin.target}" ];
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

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
