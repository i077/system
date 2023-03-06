{inputs, ...}: {
  imports = [./hardware-configuration.nix inputs.nixos-hardware.nixosModules.microsoft-surface-common];

  boot.loader.systemd-boot.enable = true;

  networking = {
    hostName = "staryu";
    networkmanager.enable = true;
  };

  # Lock, but don't suspend, on lid close
  # This is meant to run server workloads
  services.logind.lidSwitch = "lock";
  
  # Enable distributed builds
}
