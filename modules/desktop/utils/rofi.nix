{ config, lib, ... }:

let
  cfg = config.modules.desktop.utils.rofi;
  inherit (lib) mkEnableOption mkIf;

  inherit (config.modules.theming) colors;
  isHiDPI = config.modules.hardware.video.hidpi.enable;
in {
  options.modules.desktop.utils.rofi.enable = mkEnableOption "Rofi";

  config = mkIf cfg.enable {
    hm.programs.rofi = {
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

      font = with config.modules.theming.fonts;
        ui.family + " " + toString (12 * (if isHiDPI then 2 else 1));

      extraConfig = ''
        rofi.dpi = ${toString (96 * (if isHiDPI then 2 else 1))}
      '';
    };
  };
}
