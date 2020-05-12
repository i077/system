{ config, device, ... }:

let inherit (config.theming) colors;
in {
  home-manager.users.imran.programs.rofi = {
    enable = true;
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

    font = with config.theming.fonts;
      ui.family + " "
      + toString (12 * (if device.isHiDPI then 2 else 1));

    extraConfig = ''
      rofi.dpi = ${toString (96 * (if device.isHiDPI then 2 else 1))}
    '';
  };
}
