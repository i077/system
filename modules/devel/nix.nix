# modules/devel/nix.nix -- Nix-related development tools

{ config, lib, pkgs, options, ... }:

let
  cfg = config.modules.devel.nix;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.devel.nix.enable = mkEnableOption "Nix development tools";

  config = mkIf cfg.enable {
    hm = {
      home.packages = with pkgs; [
        manix
        nixfmt
        nix-diff
        nixpkgs-review

        nix-index
      ];

      # Service to periodically update the nix-index database
      systemd.user.services.nix-index-update = {
        Unit = {
          Description = "Update the nix-index database";
          After = [ "network-online.target" ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = toString (pkgs.writeScript "nix-index-update" ''
            #!${pkgs.runtimeShell}
            tag=$(git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --tags --sort='v:refname' \
                https://github.com/Mic92/nix-index-database \
                | awk 'END {match($2, /([^/]+)$/, m); print m[0]}')
            curl -L "https://github.com/Mic92/nix-index-database/releases/download/$tag/files" -o $XDG_RUNTIME_DIR/files-$tag
            mv $XDG_RUNTIME_DIR/files-$tag $HOME/.cache/nix-index/files'');

          # This isn't urgent, just wait until no one else needs the disk
          IOSchedulingClass = "idle";
        };
      };

      # Mic92's repo updates every Sunday 02:51 UTC, so run that next morning.
      systemd.user.timers.nix-index-update = {
        Unit.Description = "Update the nix-index database";
        Timer.OnCalendar = "Sunday 10:00";
        Install.WantedBy = [ "timers.target" ];
      };
    };
  };
}
