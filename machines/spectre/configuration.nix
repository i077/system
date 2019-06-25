{ config, pkgs, ... }:

let unstableTarball = 
  fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./services.nix
      ./yubikey.nix
    ];

  # Swapfile
  swapDevices = [
    {device = "/var/swapfile"; size = 8192;}
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Optimize for SSDs
  fileSystems."/".options = [ "discard" ];

  # Define encrypted partition (extended from hardware-configuration)
  boot.initrd.luks.devices."cryptroot" = {
    preLVM = true;
    allowDiscards = true;
  };

  # Support exFAT filesystems
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

  networking.hostName = "Imran-SpectreNix"; # Define your hostname.

  nixpkgs.config = {
    # Allow unfree software
    allowUnfree = true;

    # Allow some packages from unstable, so less essential packages get upgraded more quickly
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  # NVIDIA
  hardware.nvidiaOptimus.disable = true;
  hardware.opengl.extraPackages = [ pkgs.linuxPackages.nvidia_x11.out ];
  hardware.opengl.extraPackages32 = [ pkgs.linuxPackages.nvidia_x11.lib32 ];
  # TODO get primerun script from https://nixos.wiki/wiki/Nvidia

  # Set timezone
  time.timeZone = "America/New_York";

  # System packages
  environment.systemPackages = with pkgs; [
    acpi
    binutils
    file
    firefox
    gitFull
    gnupg
    htop
    unstable.keybase
    unstable.keybase-gui
    light
    unstable.neovim
    openconnect
    python3Full
    python3Packages.pip
    powertop
    ripgrep
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.imran = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = "/run/current-system/sw/bin/fish";
  };

  # Fish shell
  programs.fish.enable = true;

  system.stateVersion = "19.03";
}
