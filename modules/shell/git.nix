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
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hm.programs.git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;

        inherit (cfg) userName userEmail;
        signing.key = "211F871962EA405B";

        aliases = {
          ca = "commit --amend";
          call = "commit -a";
          credo = "commit --amend --no-edit";
          credoall = "commit --amend --no-edit -a";
          ci = "commit -v";
          co = "checkout";
          cob = "checkout -b";
          f = "fetch";
          ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
          l = "log";
          lg = "log --oneline --graph --decorate";
          lga = "log --oneline --graph --decorate --all";
          pd = "pull";
          pdu = "pull upstream";
          pdum = "pull upstream master";
          pu = "push";
          pushall = "!git remote | xargs -L1 git push --all";
          st = "status";
        };

        extraConfig = {
          core.editor = config.modules.editors.default;
          pull.rebase = false;

          init.defaultBranch = "main";
        };
      };

      # Add git extensions & utilities
      hm.home.packages = with pkgs; [ gitAndTools.gh git-crypt lazygit sublime-merge ];
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
  ]);
}
