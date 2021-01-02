{ config, lib, ... }:

let
  cfg = config.modules.editors;
  inherit (lib) mkIf mkOption types;
in {
  options.modules.editors = {
    default = mkOption {
      description = "Default editor.";
      type = types.str;
    };
  };

  config = mkIf (cfg.default != null) { environment.variables.EDITOR = cfg.default; };
}
