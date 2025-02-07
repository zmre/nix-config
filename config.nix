{
  allowUnsupportedSystem = true;
  allowBroken = false;
  allowUnfree = true;
  experimental-features = "nix-command flakes";
  keep-derivations = false;
  keep-outputs = false;
  keep-failed = true;
  download-buffer-size = 134217728;
  # number of lines of a build log to show on failure (default is 25)
  log-lines = 45;
}
