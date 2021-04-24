# roles/personal.nix -- Modules to enable for a personal machine

{ config, inputs, lib, pkgs, ... }:

let inherit (config.home-manager.users.${config.user.name}) xdg;
in {
  imports = [ ./home-manager.nix ./xdg.nix ];

  # Add bin to PATH
  environment.extraInit = "export PATH=/etc/nixos/bin:$PATH";

  boot = {
    # Use Liquorix kernel, achieves better performance for desktops
    kernelPackages = pkgs.linuxPackages_lqx;

    # Plymouth boot screen
    plymouth.enable = true;

    # Allow cross-compilation of AArch64 configurations
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    # Support mounting other filesystems
    supportedFilesystems = [ "ntfs" "exfat" ];
  };

  time.timeZone = "America/New_York";

  # Allow unfree evaluation
  nixpkgs.config.allowUnfree = true;
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  # User CLI packages
  hm.home.packages = with pkgs; [
    acpi
    exa
    fd
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

  programs.ssh.startAgent = true;

  modules = {
    security.yubikey = {
      enable = true;
      lock-on-remove = true;
    };

    desktop = {
      gnome3.enable = true;
      apps = {
        bitwarden = {
          enable = true;
          cli.enable = true;
        };
        everdo.enable = true;
        firefox.enable = true;
        keybase.enable = true;
        vscode.enable = true;
        zathura.enable = true;
      };
      term = {
        kitty.enable = true;
        default = "kitty";
      };
    };

    devel = {
      nix.enable = true;
      python.enable = true;
      python.ptpython.enable = true;
      latex.enable = true;
      rust.enable = true;
    };

    editors = {
      neovim.enable = true;
      default = "nvim";
    };

    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
    };

    services = {
      backup = {
        enable = true;
        paths = [ "/home/${config.user.name}" "/etc" ];
        excludes = [
          "${xdg.cacheHome}"
          # Exclude Keybase caches -- too much useless data
          "${xdg.dataHome}/keybase/*.leveldb" # */
          "${xdg.dataHome}/keybase/*cache" # */
        ];
        calendar = "*-*-* 00/3:00:00";
      };
      printing.enable = true;
      nix-distributed.enable = true;
    };

    shell = {
      fish.enable = true;

      bat.enable = true;
      broot.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      git = {
        enable = true;
        sendemail = true;
        gh.enable = true;
      };
      gnupg.enable = true;
      password-store.enable = true;
      rclone.enable = true;
      starship.enable = true;
      tmux.enable = true;
    };

    theming = {
      colorscheme = "spacegray";

      fonts = rec {
        sans = {
          family = "Source Sans Pro";
          size = 8;
          pkg = pkgs.source-sans-pro;
        };
        serif = {
          family = "Source Serif Pro";
          size = 8;
          pkg = pkgs.source-serif-pro;
        };
        mono = {
          family = "JetBrains Mono";
          size = 8;
          pkg = pkgs.jetbrains-mono;
        };
        ui = sans;
      };
    };
  };
}
