{
  allowUnfree = true;
  experimental-features = "nix-command flakes";
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
  };
  bash-prompt = "";
  bash-prompt-suffix = "ns";
}
