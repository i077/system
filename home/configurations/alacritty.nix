{ config, lib, pkgs, ... }:

let
  # Need to replace '#' in colors with '0x'
  myColors = with lib;
    mapAttrs (name: value: "0x" + (removePrefix "#" value)) (import ../colors.nix);
in lib.mkIf config.programs.alacritty.enable {
  programs.alacritty.settings = {
    font = {
      normal.family = "Jetbrains Mono";
      bold.family = "Jetbrains Mono";
      italic.family = "Jetbrains Mono";

      size = 8;
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
