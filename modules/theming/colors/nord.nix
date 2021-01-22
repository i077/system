{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.theming;
in mkIf (cfg.colorscheme == "nord") {
  modules.theming.colors = let
    c-dark0 = "#2e3440";
    c-dark1 = "#3b4252";
    c-dark2 = "#434c5e";
    c-dark3 = "#4c566a";
    c-light0 = "#eceff4";
    c-light1 = "#e5e9f0";
    c-light2 = "#d8dee9";
    c-blue0 = "#8fbcbb";
    c-blue1 = "#88c0d0";
    c-blue2 = "#81a1c1";
    c-blue3 = "#5e81ac";
    c-red = "#bf616a";
    c-orange = "#d08770";
    c-yellow = "#ebcb8b";
    c-green = "#a3be8c";
    c-purple = "#b48ead";
  in {
    bg0 = c-dark0;
    bg1 = c-dark1;
    bg2 = c-dark2;
    bg3 = c-dark3;
    fg0 = c-light0;
    fg1 = c-light1;
    fg2 = c-light2;
    fg3 = c-blue2;
    alert = c-red;
    primary = c-blue1;
    secondary = c-green;
    tertiary = c-purple;
    quaternary = c-orange;
    quinary = c-yellow;
    senary = c-blue3;
    septary = c-blue0;
  };

  # neovim
  hm.programs.neovim = {
    extraConfig = ''
      color nord
    '';
  };

  # git delta
  hm.programs.git.delta.options.syntax-theme = "Nord";

  # bat
  hm.programs.bat.config.theme = "Nord";

  # kitty
  hm.programs.kitty = {
    extraConfig = ''
      # black
      color0                #3B4252
      color8                #4C566A
      # red
      color1                #BF616A
      color9                #BF616A
      # green
      color2                #A3BE8C
      color10               #A3BE8C
      # yellow
      color3                #EBCB8B
      color11               #EBCB8B
      # blue
      color4                #81A1C1
      color12               #81A1C1
      # magenta
      color5                #B48EAD
      color13               #B48EAD
      # cyan
      color6                #88C0D0
      color14               #8FBCBB
      # white
      color7                #E5E9F0
      color15               #B48EAD

      foreground            #D8DEE9
      background            #2E3440
      selection_foreground  #000000
      selection_background  #FFFACD
      url_color             #0087BD
      cursor                #81A1C1
    '';
  };
}
