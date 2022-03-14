{ config, pkgs, ... }:
{

  # skhd -- most of my keys started with fn-something or that to trigger a mode
  # and now... not working.
  # https://github.com/koekeishiya/skhd/issues/193
  #services.skhd = {
  #enable = true;
  #skhdConfig = builtins.readFile ../home-manager/dotfiles/skhdrc;
  #};
  # Does not work on Monterey with an M1. See:
  # https://github.com/koekeishiya/yabai/issues/1054
  #services.yabai = {
  #enable = true;
  #package = pkgs.yabai;
  #enableScriptingAddition = false;
  #config = {
  #focus_follows_mouse = "off";
  #mouse_follows_focus = "off";
  #window_gap = 10;
  #window_border = "on";
  #window_border_placement = "inset";
  #layout = "bsp";
  #};
  #extraConfig = ''
  ## rules
  #yabai -m rule --add app='System Preferences' manage=off
  #yabai -m rule --add app='Raycast' manage=off
  #
  ## Any other arbitrary config here
  #'';
  #
  #};

}
