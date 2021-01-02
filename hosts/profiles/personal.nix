# hosts/personal.nix -- Modules to enable for a personal machine

{ config, pkgs, ... }:

{
  modules = {
    security.yubikey.enable = true;

    desktop = {
      gnome3.enable = true;
      apps = {
        firefox.enable = true;
        keybase.enable = true;
        vscode.enable = true;
        zathura.enable = true;
      };
      term = {
        alacritty.enable = true;
        default = "alacritty";
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
        excludes = [ "${config.environment.variables.XDG_CACHE_HOME}" ];
      };
      printing.enable = true;
    };

    shell = {
      fish.enable = true;

      bat.enable = true;
      broot.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      git.enable = true;
      gnupg = {
        enable = true;
        sshAgent = true;
      };
      password-store.enable = true;
      rclone.enable = true;
      starship.enable = true;
      tmux.enable = true;
    };

    theming = {
      colorscheme = "gruvbox-dark";
      vimColorscheme = "gruvbox";
      batTheme = "gruvbox";
      gitDeltaTheme = "gruvbox";

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
          family = "Iosevka";
          size = 8;
          pkg = pkgs.iosevka;
        };
        ui = sans;
      };
    };
  };
}
