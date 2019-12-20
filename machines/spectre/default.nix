{ config, pkgs, ... }:

with pkgs;
let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;

  my-python3Full = unstable.python3Full.withPackages (ps: with ps; [
    matplotlib
    notebook
    numpy
    rope
    setuptools
    scipy
    scikitlearn
    sympy
    cython
    jedi
    python-language-server
  ]);
in
{
  imports =
    [
      ./backup.nix
      ./hardware-configuration.nix
      ./keybase.nix
      ./printing.nix
      ./services.nix
      ./yubikey.nix

      # Home manager
      <home-manager/nixos>

      # Used for Brother scanners
      <nixpkgs/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix>
    ];

  networking.hostName = "i077-spectrenix";

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

  # Clean up /tmp on boot
  boot.cleanTmpDir = true;

  nixpkgs.config = {
    # Allow unfree software
    allowUnfree = true;

    packageOverrides = pkgs: {
      # Allow some packages from unstable, so less essential packages get upgraded more quickly
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };

  # OpenGL
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
  };

  # NVIDIA
  hardware.bumblebee.enable = true;

  # Audio + bluetooth
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  hardware.bluetooth = {
    enable = true;
    extraConfig = ''
      [General]
      Enable=Source,Sink,Media,Socket
    '';
  };

  # Set timezone
  time.timeZone = "America/New_York";

  # Optimize nix store automatically
  nix.autoOptimiseStore = true;

  # System packages
  environment.systemPackages = with pkgs; [
    acpi
    binutils
    file
    freetype
    gdb
    gitFull
    gnome3.gnome-tweak-tool
    gnupg
    htop
    unstable.interception-tools
    unstable.openjdk12
    keybase-gui
    libsecret
    light
    unstable.neovim
    nix-index
    nodejs
    openconnect
    patchelf
    pciutils
    pkg-config
    psmisc
    my-python3Full
    powertop
    qt5.qtbase
    rclone
    ripgrep
    unzip
    wget
    yarn

    manpages
    stdmanpages
  ];

  documentation = {
    dev.enable = true;
    man.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Users
  users.users.imran = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = "/run/current-system/sw/bin/fish";
  };
  home-manager.users.imran = import /home/imran/system/home/home.nix;
  home-manager.useUserPackages = true;

  # Fish shell
  programs.fish.enable = true;

  system.stateVersion = "19.03";
}
