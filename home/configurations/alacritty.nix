{ config, lib, pkgs, ... }:

let
  # Need to replace '#' in colors with '0x'
  myColors = with lib;
    mapAttrs (name: value: "0x" + (removePrefix "#" value)) (import ../colors.nix);
in lib.mkIf config.programs.alacritty.enable {
  programs.alacritty.settings = {
    background_opacity = 0.8;

    font = {
      normal.family = "Iosevka";
      bold.family = "Iosevka";
      italic.family = "Iosevka";

      size = 12.0;
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
        blue = senary;
        magenta = tertiary;
        cyan = septary;
        white = fg0;
      };
    };
  };
}
