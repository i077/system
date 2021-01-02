{ config, lib, ... }:

let
  cfg = config.modules.desktop.term;
  inherit (lib) mkIf mkOption types;
in {
  options.modules.desktop.term = {
    default = mkOption {
      description = "Default terminal.";
      type = types.str;
    };
  };

  config = mkIf (cfg.default != null) { environment.variables.TERMINAL = cfg.default; };
}
