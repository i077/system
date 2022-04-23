{ config, lib, pkgs, ... }:
let hostName = "Venusaur";
in {
  imports =
    [ ./brew.nix ./home.nix ../../modules/darwin/fish.nix ../../modules/darwin/1password.nix ];

  # User config
  users.users.imran.home = "/Users/imran";

  networking = {
    computerName = hostName;
    inherit hostName;
  };

  # Enable touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Enable x86 builds
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  nixpkgs.config = {
    allowUnfree = true;
    input-fonts.acceptLicense = true;
  };

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [ input-fonts ];
}
