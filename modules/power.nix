{ config, device, lib, pkgs, ... }:

{
  services.udev.extraRules = lib.optionalString device.isLaptop ''
    ACTION=="add|change", KERNEL=="sd*[!0-9]|sr*", ATTR{queue/scheduler}="bfq"
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl start battery"
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl start ac"
  '';

  systemd.services.battery = {
    enable = device.isLaptop;
    description = "Runs commands upon switching to battery power";
    script = ''
      ${config.boot.kernelPackages.cpupower}/bin/cpupower frequency-set -g powersave
    '';
  };

  systemd.services.ac = {
    enable = device.isLaptop;
    description = "Runs commands upon switching to AC power";
    script = ''
      ${config.boot.kernelPackages.cpupower}/bin/cpupower frequency-set -g performance
    '';
  };
}
