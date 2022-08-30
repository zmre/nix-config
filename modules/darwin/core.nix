{ inputs, config, pkgs, ... }:
let prefix = "/run/current-system/sw/bin";
in {
  # environment setup
  environment = {
    loginShell = pkgs.zsh;
    pathsToLink = [ "/Applications" ];
    # I exclusively control homebrew from here, but it's annoying to fully qualify the path to brew binaries
    systemPath = [ "/opt/homebrew/bin" ];
    #backupFileExtension = "backup";
    etc = { darwin.source = "${inputs.darwin}"; };
    # Use a custom configuration.nix location.
    # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix

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
      # Use scroll gesture with the Ctrl (^) modifier key to zoom
      #defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
      #defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
      # Follow the keyboard focus while zoomed in
      #defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true
      # Require password immediately after sleep or screen saver begins
       defaults write com.apple.screensaver askForPassword -int 1
       defaults write com.apple.screensaver askForPasswordDelay -int 0
      # Save screenshots to the desktop
      defaults write com.apple.screencapture location -string "/Users/${config.user.name}/Desktop"
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
      # Use list view in all Finder windows by default
      # Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
      defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
      # Show the ~/Library folder
      #chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library
      # Privacy: don’t send search queries to Apple
      defaults write com.apple.Safari UniversalSearchEnabled -bool false
      defaults write com.apple.Safari SuppressSearchSuggestions -bool true
      # Press Tab to highlight each item on a web page
      defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
      defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true
      # Show the full URL in the address bar (note: this still hides the scheme)
      defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
      # Prevent Safari from opening ‘safe’ files automatically after downloading
      defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
      # Disallow hitting the Backspace key to go to the previous page in history
      defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool false

      # Hide Safari’s bookmarks bar by default
      defaults write com.apple.Safari ShowFavoritesBar -bool false
      # Enable Safari’s debug menu
      defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
      # Enable the Develop menu and the Web Inspector in Safari
      defaults write com.apple.Safari IncludeDevelopMenu -bool true
      defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
      defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
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
      # Block pop-up windows
      defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
      defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false
      # Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
      defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"
      # Display emails in threaded mode, sorted by date (newest at the top)
      defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
      defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "no"
      defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

      # Disable inline attachments (just show the icons)
      defaults write com.apple.mail DisableInlineAttachmentViewing -bool true
      defaults write com.apple.spotlight orderedItems -array \
      	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
      	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
      	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
      	'{"enabled" = 0;"name" = "CONTACT";}' \
      	'{"enabled" = 1;"name" = "PDF";}' \
      	'{"enabled" = 0;"name" = "FONTS";}' \
      	'{"enabled" = 1;"name" = "DOCUMENTS";}' \
      	'{"enabled" = 1;"name" = "MESSAGES";}' \
      	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
      	'{"enabled" = 1;"name" = "IMAGES";}' \
      	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
      	'{"enabled" = 0;"name" = "MUSIC";}' \
      	'{"enabled" = 0;"name" = "MOVIES";}' \
      	'{"enabled" = 1;"name" = "PRESENTATIONS";}' \
      	'{"enabled" = 1;"name" = "SPREADSHEETS";}' \
      	'{"enabled" = 0;"name" = "SOURCE";}' \
      	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
      	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
      	'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
      	'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
      	'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
      	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

           # Prevent Time Machine from prompting to use new hard drives as backup volume
      defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
      # Enable the automatic update check
      defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

      # Check for software updates daily, not just once per week
      defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
      # Download newly available updates in background
      defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

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
  #networking.dns = [ "127.0.0.1" "1.1.1.1" ];
  # So the nextdns installed by nix is not signed and apple refuses to run it.
  # Switching to the version from the App store
  # services.nextdns = {
  #   enable = true;
  #   arguments = [ "-config" "f73bff" ];
  # };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  fonts.fontDir.enable =
    true; # if this is true, manually installed system fonts will be deleted!
  fonts.fonts = with pkgs; [
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
  security.pam.enableSudoTouchIdAuth = true;

}
