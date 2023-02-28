{
  lib,
  pkgs,
  home,
  ...
}: {
  # Can't use networking.extraHosts outside of NixOS, so this hack:
  # company colors -- may still need to "install" them from a color picker window
  home.file."Library/Colors/IronCore-Branding-June-17.clr".source =
    ./dotfiles/IronCore-Branding-June-17.clr;

  # stolen from https://github.com/nix-community/home-manager/issues/1341
  disabledModules = ["targets/darwin/linkapps.nix"]; # so we can use shortcuts instead of symlinks
  home.activation.aliasApplications =
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
    (lib.hm.dag.entryAfter ["writeBoundary"] ''
      app_folder="Home Manager Apps"
      app_path="$(echo ~/Applications)/$app_folder"
      tmp_path="$(mktemp -dt "$app_folder.XXXXXXXXXX")" || exit 1
      echo app_folder=\"$app_folder\"
      echo app_path=\"$app_path\"
      echo tmp_path=\"$tmp_path\"
      # NB: aliasing ".../home-path/Applications" to
      #    "~/Applications/Home Manager Apps" doesn't work (presumably
      #     because the individual apps are symlinked in that directory, not
      #     aliased). So this makes "Home Manager Apps" a normal directory
      #     and then aliases each application into there directly from its
      #     location in the nix store.
      OIFS="$IFS"
      IFS=$'\n'
      for app in \
        $(find "$newGenPath/home-path/Applications" -type l -exec \
          readlink -f {} \;)
      do
        echo app=$app
        $DRY_RUN_CMD /usr/bin/osascript \
          -e "tell app \"Finder\"" \
          -e "make new alias file at POSIX file \"$tmp_path\" \
                                  to POSIX file \"$app\"" \
          -e "set name of result to \"$(basename $app)\"" \
          -e "end tell"
      done
      IFS="$OIFS"
      $DRY_RUN_CMD [ -e "$app_path" ] && rm -r "$app_path"
      $DRY_RUN_CMD mv "$tmp_path" "$app_path"
    '');
}
