{
  pkgs,
  lib,
  ...
}: let
  bright = pkgs.writeShellApplication {
    name = "bright.sh";
    # Below are needed for bright.sh script, but this is an import in home-manager and homebrew is set under darwin so...
    # these are moving over there.
    # homebrew.brews = [
    #   "brightness"
    #   "ddcctl"
    # ];
    runtimeInputs = [];
    text = builtins.readFile ./dotfiles/scripts/bright.sh;
  };
  yt = pkgs.writeShellApplication {
    name = "yt";
    runtimeInputs = with pkgs; [yt-dlp];
    # update 2025-01-16
    # started getting 403 errors and tried a bunch of things; ultimately using the ios client and not using cookies solved for me, per this thread:
    # https://github.com/yt-dlp/yt-dlp/issues/10046
    # but i suspect this is only sometimes the right answer so I've added the modified command that worked for me to run only if yt-dlp has a non-zero exit code on first try
    # with a three second sleep in there
    text = ''
      yt-dlp -f 'bv*+ba/b' --remux-video mp4 --embed-subs --write-auto-sub --embed-thumbnail --write-subs --sub-langs 'en.*,en-orig,en' --embed-chapters --sponsorblock-mark default --sponsorblock-remove default --no-prefer-free-formats --check-formats  --merge-output-format "mp4/m4v" --embed-metadata --cookies-from-browser safari --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36' "$1" || sleep 3 && yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b" --remux-video mp4 --embed-subs --write-auto-sub --embed-thumbnail --write-subs --sub-langs 'en.*,en-orig,en' --embed-chapters --sponsorblock-mark default --sponsorblock-remove default --no-prefer-free-formats --check-formats  --merge-output-format "mp4/m4v" --embed-metadata  --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36' --extractor-args "youtube:player_client=ios" "$1"
    '';
  };
  yt-fix = pkgs.writeShellApplication {
    name = "yt-fix";
    runtimeInputs = with pkgs; [ffmpeg deterministic-uname];
    text = builtins.readFile ./dotfiles/scripts/yt-fix;
  };
  # syncm = pkgs.writeShellApplication {
  #   name = "syncm";
  #   runtimeInputs = [pkgs.rsync];
  #   text = "rsync -avhP --delete --progress \"$HOME/Sync/Private/PW Projects/Magic/Videos/\" pwalsh@synology1.savannah-basilisk.ts.net:/volume1/video/Magic/";
  # };
  desktop-hide = pkgs.writeShellApplication {
    name = "desktop-hide";
    runtimeInputs = [];
    text = ''
      defaults write com.apple.finder CreateDesktop false
      killall Finder
    '';
  };
  desktop-show = pkgs.writeShellApplication {
    name = "desktop-show";
    runtimeInputs = [];
    text = ''
      defaults write com.apple.finder CreateDesktop true
      killall Finder
    '';
  };
  transcribe-rode-meeting = pkgs.writeShellApplication {
    name = "transcribe-rode-meeting";
    runtimeInputs = with pkgs; [ffmpeg openai-whisper-cpp];
    text = builtins.readFile ./dotfiles/scripts/transcribe-rode-meeting;
  };
  transcribe-video-to-subtitles = pkgs.writeShellApplication {
    name = "transcribe-video-to-subtitles";
    runtimeInputs = with pkgs; [ffmpeg openai-whisper-cpp];
    text = builtins.readFile ./dotfiles/scripts/transcribe-video-to-subtitles;
  };
in {
  home.packages =
    [
      yt
      #syncm
      yt-fix
      transcribe-rode-meeting
      transcribe-video-to-subtitles
    ]
    ++ lib.optionals (pkgs.stdenvNoCC.isLinux) []
    ++ lib.optionals (pkgs.stdenvNoCC.isDarwin) [
      bright
      desktop-hide
      desktop-show
    ];
}
