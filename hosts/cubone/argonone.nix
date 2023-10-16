{
  inputs,
  lib,
  pkgs,
  ...
}: let
  fancontrol-pkg = pkgs.buildGoModule {
    name = "argonone-fancontrold";
    version = "0.1.0";
    src = inputs.argonone-utils;
    vendorSha256 = "18qwmg249lr7xb9f7lrrflhsr7drx750ndqd8hirq5hgj4c4f66k";
    meta.mainProgram = "argonone-fancontrold";
  };
in {
  imports = [
    "${inputs.argonone-utils}/nix/hardware/i2c.nix"
    "${inputs.argonone-utils}/nix/hardware/power-button.nix"
  ];

  # Enable I2C for fan control
  boot.initrd.kernelModules = ["i2c-dev" "i2c-bcm2835"];
  boot.kernelModules = ["i2c-dev" "i2c-bcm2835"];
  hardware.i2c.enable = true;
  hardware.raspberry-pi."4".i2c-bcm2708.enable = true;

  # Enable fan controller
  systemd.services.argonone-fancontrold = {
    enable = true;
    wantedBy = ["default.target"];

    serviceConfig = {
      DynamicUser = true;
      Group = "i2c";
      ExecStart = lib.getExe fancontrol-pkg;
    };
  };
}
