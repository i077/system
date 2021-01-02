{ config, lib, pkgs, options, ... }:

let
  cfg = config.modules.hardware.fs;
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
in {
  options.modules.hardware.fs = {
    ssd.enable = mkEnableOption "TRIM for SSDs";

    swapsize = mkOption {
      description = "Size of swap file in /var/swapfile. If set to 0, no swapfile is made.";
      type = types.int;
      default = 4096;
    };
  };

  config = (mkMerge [
    {
      # Add some packages for mounting other filesystems
      environment.systemPackages = with pkgs; [ ntfs3g exfat ];

      # Define swap
      swapDevices = [
        (mkIf (cfg.swapsize > 0) {
          device = "/var/swapfile";
          size = cfg.swapsize;
        })
      ];
    }
    (mkIf cfg.ssd.enable {
      services.fstrim.enable = true;
      boot.initrd.luks.devices."cryptroot".allowDiscards = true;
      fileSystems."/".options = [ "discard" ];
    })
  ]);
}
