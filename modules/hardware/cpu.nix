{ config, lib, options, ... }:

let
  cfg = config.modules.hardware.cpu;
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
in {
  options.modules.hardware.cpu = {
    vendor = mkOption {
      description =
        "CPU vendor. Used to enable microcode updates for now, so set to null to disable.";
      type = types.nullOr (types.enum [ "intel" "amd" ]);
    };
  };

  config = mkIf (cfg.vendor != null) { hardware.cpu.${cfg.vendor}.updateMicrocode = true; };
}
