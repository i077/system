{ config, lib, pkgs, ... }:

let
  colors = import ../colors.nix;
in lib.mkIf config.programs.rofi.enable {
  programs.rofi = {
    colors = {
      window = {
        background = colors.bg0;
        border = colors.primary;
        separator = colors.primary;
      };

      rows = {
        normal = {
          background = colors.bg0;
          backgroundAlt = colors.bg1;
          foreground = colors.fg0;
          highlight = {
            background = colors.fg0;
            foreground = colors.bg0;
          };

        };

        active = {
          background = colors.bg0;
          backgroundAlt = colors.bg1;
          foreground = colors.secondary;
          highlight = {
            background = colors.secondary;
            foreground = colors.bg0;
          };
        };
      };
    };

    font = "Jetbrains Mono 24";

    extraConfig = ''
      rofi.dpi = 192
    '';
  };
}
