{ config, pkgs, ... }:

with pkgs;
let unstableTarball = 
  fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
  my-py-packages = python-packages: with python-packages; [
    numpy
  ];
  my-python3Full = unstable.python3Full.withPackages my-py-packages;
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./services.nix
      ./yubikey.nix

      # Used for Brother scanners
      <nixpkgs/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix>
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
  hardware.bumblebee.enable = true;

  # Set timezone
  time.timeZone = "America/New_York";

  # System packages
  environment.systemPackages = with pkgs; [
    acpi
    binutils
    file
    firefox
    freetype
    gdb
    gitFull
    gnupg
    htop
    unstable.interception-tools
    unstable.openjdk12
    unstable.keybase
    unstable.keybase-gui
    light
    unstable.neovim
    nix-index
    nodejs-11_x
    openconnect
    patchelf
    pciutils
    pkg-config
    psmisc
    my-python3Full
    unstable.python3Packages.pip
    unstable.python3Packages.setuptools
    powertop
    qt5.qtbase
    ripgrep
    unzip
    vivaldi
    wget
    yarn
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      brlaser
      brgenml1cupswrapper
      brgenml1lpr
    ];
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  # Scanning
  hardware.sane = {
    enable = true;
    brscan4 = {
      enable = true;
      netDevices = {
        home = { model = "MFC-9130CW"; ip = "192.168.86.110"; };
      };
    };
  };

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
