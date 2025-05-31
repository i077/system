{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) concatStringsSep isBool isFloat isInt isString mapAttrsToList;

  boolToPyBool = b:
    if b
    then "True"
    else "False";

  rawPy = value: {__raw = value;};

  attrsToPyStmts = attrs:
    concatStringsSep "\n    " (mapAttrsToList (n: v: "repl.${n} = ${
        if (isBool v)
        then (boolToPyBool v)
        else if (isInt v || isFloat v)
        then "${toString v}"
        else if (isString (v.__raw or null))
        then v.__raw
        else ''"${v}"''
      }")
      attrs);

  # See https://github.com/prompt-toolkit/ptpython/blob/main/examples/ptpython_config/config.py
  # for available options
  ptpythonCfg = {
    show_signature = true;
    show_docstring = true;

    show_line_numbers = true;
    highlight_matching_parenthesis = true;

    enable_mouse_support = true;

    vi_mode = true;
    cursor_shape_config = "Modal (vi)";
    enable_open_in_editor = true;

    completion_visualization = rawPy "CompletionVisualisation.POP_UP";
  };

  colorscheme = "native";
in {
  home.packages = [pkgs.uv];
  home.sessionVariables.PTPYTHON_CONFIG_HOME = "${config.xdg.configHome}/ptpython";

  xdg.configFile."ptpython/config.py".text = ''
    from prompt_toolkit.styles import Style

    from ptpython.layout import CompletionVisualisation

    __all__ = ["configure"]


    def configure(repl):
        ${attrsToPyStmts ptpythonCfg}
        repl.use_code_colorscheme("${colorscheme}")
  '';
}
