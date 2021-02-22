{ config, lib, ... }:

let
  cfg = config.modules.shell.direnv;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.shell.direnv.enable = mkEnableOption "Direnv";

  config = mkIf cfg.enable {
    hm.programs.direnv = {
      enable = true;
      enableNixDirenvIntegration = true;

      enableFishIntegration = config.modules.shell.fish.enable;

      stdlib = ''
        # Store .direnv in cache instead of project dir
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
                echo -n "$XDG_CACHE_HOME"/direnv/layouts/
                echo -n "$PWD" | shasum | cut -d ' ' -f 1
            )}"
        }
      '';
    };
  };
}
