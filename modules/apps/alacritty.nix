{ config, device, lib, ... }:

let
  # Need to replace '#' in colors with '0x'
  myColors = with lib;
    mapAttrs (name: value: "0x" + (removePrefix "#" value)) config.theming.colors;
  inherit (config.theming) fonts;
in {
  home-manager.users.imran.programs.alacritty.enable = true;
  home-manager.users.imran.programs.alacritty.settings = {
    font = {
      normal.family = fonts.mono.family;
      bold.family = fonts.mono.family;
      italic.family = fonts.mono.family;

      size = 14;
    };

    colors = with myColors; {
      primary = {
        background = bg0;
        foreground = fg0;
      };

      normal = {
        black = bg0;
        red = alert;
        green = secondary;
        yellow = quinary;
        blue = primary;
        magenta = tertiary;
        cyan = senary;
        white = fg0;
      };

      bright = {
        black = bg2;
        red = alert;
        green = secondary;
        yellow = quinary;
        blue = primary;
        magenta = tertiary;
        cyan = senary;
        white = fg1;
      };
    };
  };
}
