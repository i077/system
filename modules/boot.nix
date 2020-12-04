{ config, pkgs, ... }:

{
  boot = {
    # Use the systemd-boot EFI boot loader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Use latest linux kernel (default is LTS)
    kernelPackages = pkgs.linuxPackages_5_8;

    # Plymouth boot screen
    plymouth.enable = true;

    extraModulePackages = with config.boot.kernelPackages; [ ];

    # Clean up /tmp on boot
    cleanTmpDir = true;

    # Trim encrypted root partition
    initrd.luks.devices."cryptroot" = {
      preLVM = true;
      allowDiscards = true;
    };
  };
}
