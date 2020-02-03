{ config, lib, ... }:

let
  colors = import ../colors.nix;
in lib.mkIf config.programs.ptpython.enable {
  programs.ptpython = {
    replConfig = {
      show_signature = true;
      show_docstring = true;
      vi_mode = true;
      show_line_numbers = true;

      complete_while_typing = false;
      enable_history_search = true;
      enable_auto_suggest = true;

      color_depth = "DEPTH_4_BIT";
    };

    completion_visualization = "POP_UP";
  };
}
