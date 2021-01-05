{ config, lib, options, pkgs, ... }:

let
  cfg = config.modules.security;
  inherit (lib) mkEnableOption mkIf mkMerge;
in {
  options.modules.security = { yubikey.enable = mkEnableOption "Yubikey authentication"; };

  config = (mkMerge [
    {
      # Disable kernel command-line editing
      boot.loader.systemd-boot.editor = false;
    }
    (mkIf cfg.yubikey.enable {
      sops.secrets.authorized_yubikeys.owner = config.user.name;

      security.pam.yubico = {
        enable = true;
        control = "sufficient";
        mode = "challenge-response";
      };

      security.pam.services = builtins.listToAttrs (map (name: {
        inherit name;
        value = { yubicoAuth = true; };
      }) [ "login" "polkit-1" "su" "sudo" "systemd-user" "xlock" ]);

      # Add packages for yubikey management
      services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];

      # Place yubikey token in ~/.yubico/authorized_yubikeys
      hm.home.activation."yubikeysSecret" = {
        before = [ ];
        after = [ "linkGeneration" ];
        data = ''
          ln -sf ${config.sops.secrets.authorized_yubikeys.path} $HOME/.yubico/authorized_yubikeys
          chmod 444 $HOME/.yubico/authorized_yubikeys
        '';
      };
    })
  ]);
}
