{ pkgs, ... }: {
  programs.home-manager.enable = true;

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      HOMEBREW_NO_AUTO_UPDATE = 1;
    };
    packages = with pkgs; [ bitwarden-cli exa nix-index ripgrep ripgrep-all ];

    # Rebuild cache upon activation (for custom themes)
    activation."batCacheBuild" = {
      before = [ ];
      after = [ "linkGeneration" ];
      data = "${pkgs.bat}/bin/bat cache --build";
    };
  };

  programs.bat = {
    enable = true;
    config = { pager = "less -FR"; };
  };
}