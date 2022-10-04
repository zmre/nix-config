{ config, pkgs, ... }: {
  system.defaults = {
    #
    # `man configuration.nix` on mac is useful in seeing available options
    # `defaults read -g` on mac is useful to see current settings
    LaunchServices = {
      # quarantine downloads until approved
      LSQuarantine = true;
    };
    # login window settings
    loginwindow = {
      # disable guest account
      GuestEnabled = false;
      # show name instead of username
      SHOWFULLNAME = false;
      # Disables the ability for a user to access the console by typing “>console” for a username at the login window.
      DisableConsoleAccess = true;
    };

    # file viewer settings
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = true;
      QuitMenuItem = true;
      _FXShowPosixPathInTitle = true;
    };

    # trackpad settings
    trackpad = {
      # silent clicking = 0, default = 1
      ActuationStrength = 0;
      # enable tap to click
      Clicking = true;
    };

    # firewall settings
    alf = {
      # 0 = disabled 1 = enabled 2 = blocks all connections except for essential services
      globalstate = 1;
      loggingenabled = 0;
      stealthenabled = 1;
    };

    # dock settings
    dock = {
      # auto show and hide dock
      autohide = true;
      # remove delay for showing dock
      autohide-delay = 0.0;
      # how fast is the dock showing animation
      autohide-time-modifier = 0.2;
      expose-animation-duration = 0.2;
      tilesize = 48;
      launchanim = false;
      static-only = false;
      showhidden = true;
      show-recents = false;
      show-process-indicators = true;
      orientation = "bottom";
      mru-spaces = false;
      # mouse in top right corner will (5) start screensaver
      wvous-tr-corner = 5;
    };

    NSGlobalDomain = {
      # 2 = heavy font smoothing; if text looks blurry, back this down to 1
      AppleFontSmoothing = 2;
      AppleShowAllExtensions = true;
      # Dark mode
      AppleInterfaceStyle = "Dark";
      # auto switch between light/dark mode
      AppleInterfaceStyleSwitchesAutomatically = false;
      "com.apple.sound.beep.feedback" = 1;
      "com.apple.sound.beep.volume" = 0.6065307; # 50%
      "com.apple.mouse.tapBehavior" = 1; # tap to click
      "com.apple.swipescrolldirection" = true; # "natural" scrolling
      "com.apple.keyboard.fnState" = true;
      "com.apple.springing.enabled" = false;
      "com.apple.trackpad.scaling" = 3.0; # fast
      "com.apple.trackpad.enableSecondaryClick" = true;
      # enable full keyboard control
      AppleKeyboardUIMode = 3;
      AppleMeasurementUnits = "Inches";
      # no popup menus when holding down letters
      ApplePressAndHoldEnabled = false;
      # delay before repeating keystrokes
      InitialKeyRepeat = 14;
      # delay between repeated keystrokes upon holding a key
      KeyRepeat = 1;
      AppleShowScrollBars = "Automatic";
      NSScrollAnimationEnabled = true; # smooth scrolling
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      # no automatic smart quotes
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      # speed up animation on open/save boxes (default:0.2)
      NSWindowResizeTime = 0.1;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
    };
  };

}
