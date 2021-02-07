{ config, lib, pkgs, options, ... }:

let
  cfg = config.modules.devel.python;
  inherit (lib) mkEnableOption mkIf mkMerge;
in {
  options.modules.devel.python = {
    enable = mkEnableOption "Python development tools";
    ptpython.enable = mkEnableOption "ptpython REPL";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hm.home.packages = with pkgs; [
        jetbrains.pycharm-professional

        # Python environment
        (python3Full.withPackages (ps: with ps; [ numpy scipy matplotlib ]))

        # Tools
        black
        poetry
      ];
    }
    (mkIf cfg.ptpython.enable {
      hm.programs.ptpython = {
        enable = true;

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
    })
  ]);
}
