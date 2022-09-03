{ pkgs, ... }: {
  programs.git = {
    enable = true;

    userName = "Imran Hossain";
    userEmail = "hi" + "@" + "imranh.org";

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
      puu = "!head() { git rev-parse --abbrev-ref HEAD ;}; git push --set-upstream origin $(head)";

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

    ignores = [ ".DS_Store" ];

    extraConfig = {
      pull.rebase = false;
      init.defaultBranch = "main";

      # Sign with SSH key
      user.signingkey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQRxhrUwCg/DcNQfG8CwIMdJsHu0jZWI2BZV/T6ka5N";
      gpg.format = "ssh";
      commit.gpgsign = true;
    };

    # Delta diff viewer
    delta = {
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
  };

  # GitHub CLI
  programs.gh = {
    enable = true;

    settings = {
      aliases = {
        co = "pr checkout";
        cl = "repo clone";
      };
      git_protocol = "ssh";
    };

  };

  # Add git extensions & utilities
  home.packages = with pkgs; [ lazygit ];
}
