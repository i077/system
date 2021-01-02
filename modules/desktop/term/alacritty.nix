{ config, lib, ... }:
let
  cfg = config.modules.desktop.term.alacritty;
  inherit (lib) mapAttrs removePrefix mkEnableOption mkIf;
  inherit (config.modules.theming) fonts;

  # Need to replace '#' in colors with '0x'
  myColors = mapAttrs (name: value: "0x" + (removePrefix "#" value)) config.modules.theming.colors;
in {
  options.modules.desktop.term.alacritty = { enable = mkEnableOption "Alacritty terminal"; };

  config = mkIf cfg.enable {
    hm.programs.alacritty.enable = true;
    hm.programs.alacritty.settings = {
      font = {
        normal.family = fonts.mono.family;
        bold.family = fonts.mono.family;
        italic.family = fonts.mono.family;

        size = 12;
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
  };
}
