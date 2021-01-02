{ config, lib, ... }:

let
  cfg = config.modules.desktop.apps.zathura;
  inherit (lib) mkEnableOption mkIf;
  inherit (config.modules.theming) colors;

  isHiDPI = config.modules.hardware.video.hidpi.enable;
in {
  options.modules.desktop.apps.zathura.enable = mkEnableOption "Zathura document viewer";

  config = mkIf cfg.enable {
    hm.programs.zathura = {
      enable = true;
      options = {
        # Colors
        default-bg = colors.bg0;
        default-fg = colors.fg0;
        completion-bg = colors.bg2;
        completion-fg = colors.fg2;
        completion-group-bg = colors.bg2;
        completion-group-fg = colors.fg2;
        completion-highlight-bg = colors.primary;
        completion-highlight-fg = colors.bg0;
        # highlight-color = colors.quinary;
        # highlight-active-color = colors.quaternary;
        inputbar-bg = colors.bg1;
        inputbar-fg = colors.fg1;
        notification-bg = colors.fg0;
        notification-fg = colors.bg0;
        notification-error-bg = colors.alert;
        notification-error-fg = colors.bg0;
        notification-warning-bg = colors.quinary;
        notification-warning-fg = colors.bg0;
        render-loading-bg = colors.bg0;
        render-loading-fg = colors.fg0;
        statusbar-bg = colors.bg0;
        statusbar-fg = colors.fg0;

        font = with config.modules.theming.fonts;
          ui.family + " " + toString (ui.size * (if isHiDPI then 1 else 2));
      };
    };
  };
}
