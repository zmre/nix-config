{ config, lib, pkgs, ... }: {
  #home.packages = [ pkgs.docker ];

  # company colors -- may still need to "install" them from a color picker window
  home.file."Library/Colors/IronCore-Branding-June-17.clr".source =
    ./dotfiles/IronCore-Branding-June-17.clr;

  # programs.git = {
  #   userEmail = "...";
  #   userName = "...";
  #   signing = {
  #     key = "...";
  #     signByDefault = true;
  #   };
  # };

}
