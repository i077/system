# This part defines a NixOS rescue/installation ISO that can be used to bootstrap or repair systems.
{
  config,
  inputs,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs.lib) mkIf;

  flakeConfig = config;

  isLinux = system: builtins.elem system nixpkgs.lib.systems.doubles.linux;

  # Define the NixOS configuration for the rescue ISO
  rescueConfig = system:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ({
          config,
          lib,
          modulesPath,
          pkgs,
          ...
        }: {
          imports = [
            # Build on top of the GNOME installer ISO
            "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
            "${modulesPath}/installer/cd-dvd/channel.nix"
            ../modules/nixos
          ];

          isoImage.isoBaseName = "nixos-rescue";

          system.stateVersion = "20.09";
          time.timeZone = "America/New_York";

          # Use latest kernel
          boot.kernelPackages = pkgs.linuxPackages_latest;

          boot.supportedFilesystems = lib.mkForce [
            "btrfs"
            "cifs"
            "exfat"
            "ext2"
            "ext4"
            "f2fs"
            "jfs"
            "ntfs"
            "reiserfs"
            "vfat"
            "xfs"
            # "zfs" Commented out since zfs is broken on latest kernel
          ];
          networking.hostId = null;

          # Support building for other linux systems supported by this flake
          boot.binfmt.emulatedSystems =
            builtins.filter
            (supportedSystem: supportedSystem != system && isLinux supportedSystem)
            flakeConfig.systems;

          networking = {
            hostName = "rescue";
            wireless = {
              enable = true;
              userControlled.enable = true;
            };
          };

          # Add additional rescue tools
          environment.systemPackages = with pkgs; [
            coreutils
            efitools
            fd
            file
            inetutils
            jq
            lsof
            neovim
            ripgrep
            wget
          ];
          environment.variables.EDITOR = "nvim";

          # Use fish shell
          programs.fish.enable = true;
          environment.shells = [pkgs.fish];
          users.defaultUserShell = pkgs.fish;

          # Define root user
          users.users.root = {
            password = "rescue";
            openssh.authorizedKeys.keys = inputs.self.lib.mySshKeys;
          };
          users.mutableUsers = false;
        })
      ];
    };
in {
  flake.nixosConfigurations.rescue = rescueConfig "x86_64-linux";

  perSystem = {system, ...}:
    mkIf (isLinux system) {
      packages.rescueImage = (rescueConfig system).config.system.build.isoImage;
    };
}
