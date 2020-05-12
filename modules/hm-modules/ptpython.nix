{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.ptpython;

  boolToPyBool = b: if b then "True" else "False";
  attrsToPyStmts = attrs:
    concatStringsSep "\n    " (mapAttrsToList (n: v:
      "repl.${n} = ${
        if (isBool v) then
          (boolToPyBool v)
        else if (isInt v) then
          "${v}"
        else
          ''"${v}"''
      }") attrs);

in {
  options.programs.ptpython = {
    enable = mkEnableOption "An advanced Python REPL";

    completion_visualization = mkOption {
      default = "MULTI_COLUMN";
      type = types.str;
      description = ''
        Whether and in what style to show completions.
        One of "NONE", "POP_UP", "MULTI_COLUMN", or "TOOLBAR".
      '';
      example = "POP_UP";
    };

    replConfig = mkOption {
      default = { };
      type = types.attrs;
      description = ''
        Simple options for ptpython. Gets added to config.py as repl.{name} = {value}.
        Boolean options are converted to python's "True" or "False".
        See <link xlink:href="https://github.com/prompt-toolkit/ptpython/blob/master/examples/ptpython_config/config.py"
        for available options.
      '';
      example = literalExample ''
        {
          show_signature = true;
          show_docstring = true;
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    # The ptpython package must be added to the python package using python3.withPackages

    xdg.configFile."ptpython/config.py".text = ''
      from __future__ import unicode_literals
      from prompt_toolkit.filters import ViInsertMode
      from prompt_toolkit.key_binding.key_processor import KeyPress
      from prompt_toolkit.keys import Keys
      from pygments.token import Token

      from ptpython.layout import CompletionVisualisation

      __all__ = (
          'configure',
      )

      def configure(repl):
          repl.completion_visualization = CompletionVisualisation.${cfg.completion_visualization}
          ${attrsToPyStmts cfg.replConfig}
    '';
  };
}
