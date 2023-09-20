{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;

    shellAbbrs = {
      g = "git";

      l = "eza";
      ls = "eza";
      la = "eza -a";
      ll = "eza -l";
      lL = "eza -algiSH --git";
      lt = "eza -lT";

      m = "make";
      py = "ptpython";
      t = "tmux";
      ta = "tmux a -t";

      nv = "neovide";
      v = "nvim";

      # Apparently I mix these up all the time.
      ":q" = "exit";
    };

    functions = {
      lwhich = {
        description = "Show the full path of a command, resolving links along the way";
        body = ''
          if test (count $argv) -ne 1
              echo "lwhich: Expected exactly one argument."
              return 127
          end
          which $argv[1] > /dev/null; or return 1
          readlink -f (which $argv[1])
        '';
      };

      mkcd = {
        description = "Make and enter a directory";
        body = ''
          if test (count $argv) -ne 1
              echo "mkcd: Expected exactly one argument."
              return 127
          end
          mkdir $argv[1] && cd $argv[1]
        '';
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

    plugins = [
      {
        name = "z";
        src = inputs.fish-z;
      }
      {
        name = "tide";
        src = inputs.fish-tide;
      }
    ];

    shellInit = lib.optionalString pkgs.stdenvNoCC.isDarwin ''
      test -d /opt/homebrew/bin; and eval (/opt/homebrew/bin/brew shellenv)
    '';

    interactiveShellInit = ''
      test -d ~/system/bin; and set -p PATH ~/system/bin
      # Add 1Password shell plugins support
      test -f ${config.xdg.configHome}/op/plugins.sh; and source ${config.xdg.configHome}/op/plugins.sh
      # Show vi-mode in cursor
      set -g fish_cursor_default block
      set -g fish_cursor_insert line
      # Custom bindings
      bind -M insert \cs accept-autosuggestion repaint
      bind -M insert \cc kill-whole-line repaint

      # Add proper completion for aws cli: github.com/aws/aws-cli/issues/1079
      test -x (which aws_completer); and complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
    '';
  };
}
