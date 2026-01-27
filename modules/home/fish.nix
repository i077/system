{
  config,
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

      awsp = {
        description = "Set AWS profile & region";
        body = ''
          if set -q argv[1]
              set -gx AWS_PROFILE $argv[1]
          else
              set -gx AWS_PROFILE (aws configure list-profiles | fzf)
          end

          if set -q argv[2]
              set -gx AWS_REGION $argv[2]
          end
        '';
      };

      awsr = {
        body = ''
          if not set -q AWS_PROFILE
              echo "awsr: AWS_PROFILE not set."
              return 1
          end
          if set -q argv[1]
              set -gx AWS_REGION $argv[1]
          else
              set -gx AWS_REGION (aws account list-regions --output text --query 'Regions[*].[RegionName]' | fzf)
          end
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
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];

    shellInit = lib.optionalString pkgs.stdenvNoCC.isDarwin ''
      test -d /opt/homebrew/bin; and eval (/opt/homebrew/bin/brew shellenv)
    '';

    interactiveShellInit = ''
      test -d ~/system/bin; and set -p PATH ~/system/bin
      # Add 1Password shell plugins support
      test -f ${config.xdg.configHome}/op/plugins.sh; and source ${config.xdg.configHome}/op/plugins.sh

      # Vi keybindings
      set -g fish_key_bindings fish_vi_key_bindings
      set -g fish_cursor_default block
      set -g fish_cursor_insert line

      # Custom bindings
      bind -M insert \cs accept-autosuggestion repaint
      bind -M insert \cc kill-whole-line repaint

      # Add proper completion for aws cli: github.com/aws/aws-cli/issues/1079
      if test -x (which aws)
          test -x (which aws_completer); and complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
          complete --command awsp --no-files -a '(aws configure list-profiles)'
          complete --command awsp --no-files -n 'test (count (commandline -xpc)) -eq 2' -a '(aws --profile (set -l cl (commandline -xp); echo $cl[2]) account list-regions --output text --query \'Regions[*].[RegionName]\')'
          complete --command awsr --no-files -a '(set -q AWS_PROFILE; and aws account list-regions --output text --query \'Regions[*].[RegionName]\')'
      end
    '';
  };
}
