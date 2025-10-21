{
  inputs,
  system,
  pname,
  pkgs,
  ...
}: let
  rescueConfig = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      (
        {
          lib,
          modulesPath,
          pkgs,
          ...
        }: {
          imports = [
            # Build on top of the GNOME installer ISO
            "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
            "${modulesPath}/installer/cd-dvd/channel.nix"
          ];

          image.baseName = lib.mkForce "nixos-rescue";

          system.stateVersion = "20.09";
          time.timeZone = "America/New_York";

          # Support building for other linux systems supported by this flake
          boot.binfmt.emulatedSystems = builtins.filter (
            supportedSystem: supportedSystem != system
          ) ["x86_64-linux" "aarch64-linux"];

          networking = {
            hostName = "rescue";
            hostId = "44444444";
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
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQRxhrUwCg/DcNQfG8CwIMdJsHu0jZWI2BZV/T6ka5N"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsq7jgT0egpEZ4QpgaFHRRxrwk7vzWVvZE0w7Bhk9hK"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTgmWqiXS1b+l8KhvdrjZtbXXCh5UuBnbnase5601p2"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG13aSroi6VPpZII3u+0XkJyfE7ldbC6ovvMr3Fl6tMn"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1YIyqTUGvH71i6MWCsYPVoijYLZWfapmuMSR4aGAh9"
            ];
          };
          users.mutableUsers = false;
        }
      )
    ];
  };
in
  pkgs.symlinkJoin {
    name = pname;
    paths = [rescueConfig.config.system.build.isoImage];
    meta.platforms = pkgs.lib.platforms.linux;
  }
