# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/56a322e0-9520-4e5c-9ff3-f2677709dfae";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/033bf2fb-8ed7-4418-84b3-64e151f2dd20";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/50BF-5BD9";
    fsType = "vfat";
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
