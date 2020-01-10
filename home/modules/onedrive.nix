{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.onedrive;
  pkg = pkgs.onedrive;
in {
  options.services.onedrive = {
    enable = mkEnableOption "Synchronization with OneDrive";

    monitor = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to monitor OneDrive for changes in the background.";
    };

    settings = mkOption {
      type = types.attrs;
      default = {};
      example = literalExample ''
        {
          sync_dir = "~/OneDrive";
          skip_file = "~*|.~*|.tmp";
          monitor_interval = "45";
        }
      '';
      description = ''
        Configuration to be written to <filename>~/.config/onedrive/config</filename>.
        See <link xlink:href="https://github.com/abraunegg/onedrive/blob/master/docs/USAGE.md"/>
        for available options and their defaults.
        Note that integers must be expressed as strings, as in the given example.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkg ];

    systemd.user.services.onedrive = mkIf cfg.monitor {
      Unit = {
        Description = "OneDrive Free Client for %u";
        Documentation = "https://github.com/abraunegg/onedrive";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };

      Service = {
        ExecStart = "${pkg}/bin/onedrive --monitor --confdir=/home/%u/.config/onedrive";

        Restart = "on-failure";
        RestartSec = 3;
        RestartPreventExitStatus = 3;
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    # We have to write to a writable directory,
    # since onedrive writes to a database in the config directory at runtime.
    xdg.configFile."onedrive/config".text =
      concatMapStrings (e: e+"\n") (mapAttrsToList (n: v: "${n} = \"${v}\"") cfg.settings);
  };
}
