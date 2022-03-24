{ config, lib, pkgs, ... }:
let
  hostName = "Venusaur";
in {
  imports = [ ./brew.nix ];

  # Add administrators to trusted users
  nix.trustedUsers = [ "@admin" ];
  users.nix.configureBuildUsers = true;

  networking = {
    computerName = hostName;
    inherit hostName;
  };

  # Enable touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Enable flakes, x86 emulation
  nix.extraOptions = ''
    build-users-group = nixbld
    auto-optimise-store = true
    experimental-features = nix-command flakes
    max-jobs = auto
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  programs.fish.enable = true;

  environment.systemPath = [
    "${config.homebrew.brewPrefix}"
  ];

  nixpkgs.config = {
    allowUnfree = true;
    input-fonts.acceptLicense = true;
  };

  # Fonts
  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [
    input-fonts
  ];
}
