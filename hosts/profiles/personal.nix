# hosts/personal.nix -- Modules to enable for a personal machine

{ config, pkgs, ... }:

let inherit (config.home-manager.users.${config.user.name}) xdg;
in {
  boot = {
    # Use latest linux kernel (default is LTS)
    kernelPackages = pkgs.linuxPackages_latest;

    # Plymouth boot screen
    plymouth.enable = true;

    # Allow cross-compilation of AArch64 configurations
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  time.timeZone = "America/New_York";

  # User CLI packages
  hm.home.packages = with pkgs; [
    acpi
    exa
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

  modules = {
    security.yubikey.enable = true;

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
      latex.enable = true;
    };

    editors = {
      neovim = {
        enable = true;
        coc.enable = true;
      };
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
          "${xdg.dataHome}/keybase/*.leveldb" # hey vim... */
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
