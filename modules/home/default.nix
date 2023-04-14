{
  lib,
  pkgs,
  ...
}: {
  programs.home-manager.enable = true;

  home = {
    stateVersion = "20.09";

    sessionVariables = {
      EDITOR = "nvim";
      HOMEBREW_NO_AUTO_UPDATE = 1;
    };
    packages = with pkgs; [curlie exa libqalculate just jq nix-index ripgrep ripgrep-all rnix-lsp];

    # Rebuild cache upon activation (for custom themes)
    activation."batCacheBuild" = {
      before = [];
      after = ["linkGeneration"];
      data = "${lib.getExe pkgs.bat} cache --build";
    };
  };

  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      theme = "Nord";
    };
  };

  programs.broot.enable = true;

  # Include other SSH config files that I don't want to check in here
  programs.ssh.includes = ["~/.ssh/config.d/*"];

  xdg.enable = true;
}
