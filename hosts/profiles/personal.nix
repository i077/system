# hosts/personal.nix -- Modules to enable for a personal machine

{ config, pkgs, ... }:

let inherit (config.home-manager.users.${config.user.name}) xdg;
in {
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

    devel = { nix.enable = true; };

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
          "${xdg.dataHome}/keybase/*.leveldb"
          "${xdg.dataHome}/keybase/*cache"
        ];
        calendar = "*-*-* 00/3:00:00";
      };
      printing.enable = true;
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
          family = "Victor Mono";
          size = 8;
          pkg = pkgs.victor-mono;
        };
        ui = sans;
      };
    };
  };
}
