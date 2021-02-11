# modules/default.nix -- Entry point for NixOS configuration

{ config, inputs, lib, pkgs, ... }:

let inherit (lib.mine.files) mapFilesRecToList;
in {
  imports = [ inputs.home-manager.nixosModules.home-manager inputs.sops-nix.nixosModules.sops ];

  # System revision tracks git commit hash
  system.configurationRevision = lib.mkIf (inputs.self ? rev) inputs.self.rev;
  system.stateVersion = "19.03";
  hm.home.stateVersion = "20.09";

  # Bootloader
  boot = {
    # Use the systemd-boot EFI boot loader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Clean up /tmp on boot
    cleanTmpDir = true;

    initrd.luks.devices."cryptroot" = { preLVM = true; };
  };

  # Default secrets file
  sops.defaultSopsFile = ../secrets/secrets.yaml;

  # Networking
  networking.networkmanager.enable = true;
  user.extraGroups = [ "networkmanager" ];

  # For a host with no hardware-configuration.nix
  fileSystems."/".device = lib.mkDefault "/dev/disk/by-label/nixos";

  # Barebones packages
  environment.systemPackages = with pkgs; [
    file
    git
    lynx
    neovim
    psmisc # killall, pstree, ...
    rclone
    unzip
    wget

    binutils # ld, strings, strip, ...
    coreutils # All the basics: from ls and mv to kill and mktemp
    pciutils # lspci
    usbutils # lsusb

    manpages
    stdmanpages
  ];
}
