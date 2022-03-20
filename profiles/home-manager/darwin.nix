{ config, lib, pkgs, ... }: {
  #home.packages = [ pkgs.docker ];
  home.file."Library/Colors/IronCore-Branding-June-17.clr".source =
    ./dotfiles/IronCore-Branding-June-17.clr;

  # programs.git = {
  #   userEmail = "kennan@case.edu";
  #   userName = "Kennan LeJeune";
  #   signing = {
  #     key = "kennan@case.edu";
  #     signByDefault = true;
  #   };
  # };

  # home.activation = {
  #   copyApplications = let
  #     # if apps isn't set right, just hard code this below
  #     #"/var/run/current-system/etc/profiles/per-user/${config.user.name}/Applications"
  #     apps = pkgs.buildEnv {
  #       name = "home-manager-applications";
  #       paths = config.home.packages;
  #       pathsToLink = "/Applications";
  #     };
  #   in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #     for appFile in ${apps}/Applications/*; do
  #       target="/Applications/$(basename \"$appFile\")"
  #       $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
  #       rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete to be specific
  #       $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
  #     done
  #   '';
  # };

}
