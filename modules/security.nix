{ config, lib, options, pkgs, ... }:

let
  cfg = config.modules.security;
  inherit (lib) mkEnableOption mkIf mkMerge;
in {
  options.modules.security = {
    yubikey = {
      enable = mkEnableOption "Yubikey authentication";
      lock-on-remove = mkEnableOption "locking the system upon Yubikey removal";
    };
  };

  config = (mkMerge [
    (mkIf cfg.yubikey.enable (mkMerge [
      {
        sops.secrets = {
          authorized_yubikeys.owner = config.user.name;
          u2f_keys.owner = config.user.name;
        };

        security.pam.u2f = {
          enable = true;
          control = "sufficient";
          cue = true;
        };

        security.pam.services = builtins.listToAttrs (map (name: {
          inherit name;
          value = { u2fAuth = true; };
        }) [ "login" "polkit-1" "su" "sudo" "systemd-user" "xlock" ]);

        # Add packages for yubikey management
        services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];

        # Link yubikey info with right permissions
        hm.home.activation."yubikeysSecret" = {
          before = [ ];
          after = [ "linkGeneration" ];
          data = ''
            ln -sf ${config.sops.secrets.authorized_yubikeys.path} $HOME/.yubico/authorized_yubikeys
            chmod 400 $HOME/.yubico/authorized_yubikeys

            [ -d $XDG_CONFIG_HOME/Yubico ] || mkdir -p $XDG_CONFIG_HOME/Yubico
            ln -sf ${config.sops.secrets.u2f_keys.path} $XDG_CONFIG_HOME/Yubico/u2f_keys
            chmod 400 $XDG_CONFIG_HOME/Yubico/u2f_keys
          '';
        };
      }
      (mkIf cfg.yubikey.lock-on-remove {
        services.udev.extraRules = ''
          ACTION=="remove", ENV{ID_MODEL_ID}=="0116", ENV{ID_VENDOR_ID}=="1050", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
        '';
      })
    ]))
  ]);
}
