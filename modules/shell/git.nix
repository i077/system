{ config, lib, pkgs, options, ... }:

let
  cfg = config.modules.shell.git;
  inherit (lib) mkEnableOption mkMerge mkOption mkIf types;
in {
  options.modules.shell.git = {
    enable = mkEnableOption "Git version control";

    userName = mkOption {
      default = "Imran Hossain";
      type = types.str;
    };

    userEmail = mkOption {
      default = "hi" + "@" + "imranh.xyz";
      type = types.str;
    };

    delta = mkOption {
      description = "Whether to use delta for diffs.";
      default = true;
      type = types.bool;
    };

    sendemail = mkEnableOption "git-sendemail config";

    gh.enable = mkEnableOption "GitHub CLI tool";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hm.programs.git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;

        inherit (cfg) userName userEmail;
        signing.key = "211F871962EA405B";

        aliases = let
          # A nicer-looking one-line log format. Thanks @malob!
          logformat =
            "--format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %s %C(italic)- %an%C(reset)%C(magenta bold)%d%C(reset)'";
          # Small function to get the default branch in origin
          defaultBranch = remote:
            ''!b() { git remote show ${remote} | grep "HEAD branch" | sed 's/.*: //' ;};'';
        in {
          # Staging/diffs
          a = "add";
          d = "diff";
          dc = "diff --cached";
          st = "status";

          # Commit
          c = "commit --verbose";
          ca = "commit --amend --verbose";
          call = "commit --all";
          cm = "commit --message";
          credo = "commit --amend --no-edit";
          credoall = "commit --amend --no-edit --all";

          # Checkout
          co = "checkout";
          cob = "checkout -b";
          com = "${defaultBranch "origin"} git checkout $(b)";

          # Log
          l = "log";
          lg = "log --oneline --graph --decorate ${logformat}";
          lga = "log --oneline --graph --decorate --all ${logformat}";

          # Push/pull/fetch
          f = "fetch";
          pd = "pull";
          pdu = "pull upstream";
          pdum = "${defaultBranch "upstream"} git pull upstream $(b)";
          pu = "push";
          puf = "push --force-with-lease"; # as in "poof" go your old commits!
          puu =
            "!head() { git rev-parse --abbrev-ref HEAD ;}; git push --set-upstream origin $(head)";

          # Rebase
          rb = "rebase";
          rba = "rebase --abort";
          rbc = "rebase --continue";
          rbi = "rebase --interactive";

          # Stash
          sh = "stash";
          sha = "stash apply";
          shd = "stash drop";
          shl = "stash list";
          shp = "stash pop";
          shs = "stash show --patch";

          whohas = "branch -a --contains";
          ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
        };

        extraConfig = {
          core.editor = config.modules.editors.default;
          pull.rebase = false;

          init.defaultBranch = "main";
        };
      };

      # Add git extensions & utilities
      hm.home.packages = with pkgs; [ git-crypt lazygit sublime-merge ];
    }

    (mkIf cfg.delta {
      hm.programs.git.delta = {
        enable = true;
        options = {
          line-numbers = true;
          features = "decorations";
          decorations = {
            file-style = "bold white ul";
            file-decoration-style = "none";
            whitespace-error-style = "22 reverse";
          };
        };
      };
    })

    (mkIf cfg.sendemail {
      sops.secrets.git-sendemail.owner = config.user.name;

      hm.programs.git.includes = [{ path = config.sops.secrets.git-sendemail.path; }];
    })

    (mkIf cfg.gh.enable {
      hm.programs.gh = {
        enable = true;

        aliases = {
          co = "pr checkout";
          cl = "repo clone";
        };

        gitProtocol = "ssh";
      };
    })
  ]);
}
