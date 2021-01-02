# modules/default.nix -- Entry point for NixOS configuration

{ config, inputs, lib, pkgs, ... }:

let inherit (lib.mine.files) mapFilesRecToList;
in {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

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

    # Use latest linux kernel (default is LTS)
    kernelPackages = pkgs.linuxPackages_latest;

    # Plymouth boot screen
    plymouth.enable = true;

    extraModulePackages = with config.boot.kernelPackages; [ ];

    # Clean up /tmp on boot
    cleanTmpDir = true;

    initrd.luks.devices."cryptroot" = { preLVM = true; };
  };

  # Networking
  networking.networkmanager.enable = true;
  user.extraGroups = [ "networkmanager" ];

  time.timeZone = "America/New_York";

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

  # User CLI packages
  hm.home.packages = with pkgs; [
    acpi
    exa
    file
    htop
    iotop
    ix
    jq
    libqalculate
    libsecret # Used by some apps to store secrets
    openconnect
    openfortivpn
    powertop
    ranger
    ripgrep
    ripgrep-all
  ];
}
