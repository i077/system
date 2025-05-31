{pkgs, ...}: {
  programs.home-manager.enable = true;

  imports = [./ghostty.nix ./xdg.nix ./wm.nix ./ptpython.nix];

  home = {
    stateVersion = "20.09";

    sessionVariables = {
      EDITOR = "nvim";
      HOMEBREW_NO_AUTO_UPDATE = 1;

      # Disable Python virtualenv prompt updates, since tide takes care of that
      VIRTUAL_ENV_DISABLE_PROMPT = 1;
    };

    packages = with pkgs; [
      colima
      curlie
      dasel
      docker
      libqalculate
      just
      jq
      mosh
      nil
      nixd
      nix-index
      nix-output-monitor
      ripgrep
      unixtools.watch
    ];
  };

  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      theme = "gruvbox-dark";
    };
  };

  programs.eza.enable = true;

  programs.broot.enable = true;

  # Include other SSH config files that I don't want to check in here
  programs.ssh = {
    forwardAgent = true;
    includes = ["~/.ssh/config.d/*"];
  };

  programs.go.enable = true;

  xdg.enable = true;
}
