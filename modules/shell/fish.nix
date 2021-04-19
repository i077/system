{ config, inputs, lib, options, pkgs, ... }:

let
  cfg = config.modules.shell.fish;
  inherit (lib) mkEnableOption mkOption mkIf types;
in {
  options.modules.shell.fish = { enable = mkEnableOption "Fish shell"; };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.fish;
    programs.fish.enable = true;

    hm.programs.fish = {
      enable = true;

      shellAbbrs = {
        g = "git";
        l = "exa";
        ls = "exa";
        la = "exa -a";
        ll = "exa -l";
        lL = "exa -algiSH --git";
        lt = "exa -lT";
        m = "make";
        py = "ptpython";
        t = "tmux";
        ta = "tmux a -t";
        userctl = "systemctl --user";
        v = "nvim";

        # Apparently I mix these up all the time.
        ":q" = "exit";
      };

      shellAliases = {
        sysdo = "nix develop /etc/nixos -c /etc/nixos/bin/sysdo";

        # Keybase stuff
        cdkb = "cd /keybase/private/i077";
        cdkbp = "cd /keybase/public/i077";
      };

      functions = {
        lwhich = {
          description = "Show the full path of a command, resolving links along the way";
          body = "readlink -m (which $argv[1])";
        };

        # Greeting taken from bobthefish
        fish_greeting = {
          body = ''
            set_color $fish_color_autosuggestion
            uname -nmsr

            command -s uptime >/dev/null
            and command uptime

            set_color normal
          '';
        };
      };

      plugins = [{
        name = "z";
        src = inputs.fish-z;
      }];

      promptInit = ''
        # Show vi-mode in cursor
        set -g fish_cursor_default block
        set -g fish_cursor_insert line
      '';

      interactiveShellInit = ''
        # Custom bindings
        bind -M insert \cs accept-autosuggestion repaint
        bind -M insert \cc kill-whole-line repaint
      '';
    };
  };
}
