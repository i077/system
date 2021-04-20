# roles/base -- Base configuration for a machine

{ config, inputs, lib, pkgs, ... }:

{
  imports = [
    # Secrets management
    inputs.sops-nix.nixosModules.sops

    # Other files for this role
    ./nix-nixpkgs.nix
    ./user.nix
  ];

  # System revision tracks git commit hash
  system.configurationRevision = lib.mkIf (inputs.self ? rev) inputs.self.rev;
  system.stateVersion = "19.03";

  # Default secrets file
  sops.defaultSopsFile = ../../secrets/secrets.yaml;

  # SSH host keys are used for decrypting secrets, so we at least need to enable it
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # Networking
  networking.networkmanager.enable = true;
  user.extraGroups = [ "networkmanager" ];

  # Bootloader
  boot = {
    # Use the systemd-boot EFI boot loader
    loader = {
      systemd-boot = {
        enable = true;
        # Disable kernel command-line editing at boot
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };

    # Clean up /tmp on boot
    cleanTmpDir = true;
  };

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
