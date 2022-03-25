{ config, lib, pkgs, ... }:
let
  hostName = "Venusaur";
in {
  imports = [ ./brew.nix ./home.nix ../../modules/darwin/fish.nix ];

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

  programs.zsh.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    input-fonts.acceptLicense = true;
  };

  # Fonts
  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [ input-fonts ];
}
