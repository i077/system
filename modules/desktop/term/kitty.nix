{ config, lib, ... }:
let
  cfg = config.modules.desktop.term.kitty;
  inherit (lib) mapAttrs removePrefix mkEnableOption mkIf;
  inherit (config.modules.theming) fonts;
in {
  options.modules.desktop.term.kitty = { enable = mkEnableOption "Kitty terminal emulator"; };

  config = mkIf cfg.enable {
    hm.programs.kitty = {
      enable = true;

      font = {
        package = fonts.mono.pkg;
        name = fonts.mono.family;
      };

      settings = {
        bold_font = fonts.mono.family + " Bold";
        italic_font = fonts.mono.family + " Italic";
        bold_italic_font = fonts.mono.family + " Bold Italic";
        font_size = 12;
        term = "xterm-256color";
        cursor_blink_interval = 0;
        hide_window_decorations = true;
      };
    };
  };
}
