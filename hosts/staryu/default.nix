{inputs, ...}: {
  imports = [./hardware-configuration.nix inputs.nixos-hardware.nixosModules.microsoft-surface-common];
  
  boot.loader.systemd-boot.enable = true;

  networking = {
    hostName = "staryu";
    networkmanager.enable = true;
  };
}
