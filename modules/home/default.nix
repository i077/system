{
  inputs,
  pkgs,
  ...
}: {
  programs.home-manager.enable = true;

  # Import external home-manager modules
  imports = [inputs.nixvim.homeManagerModules.nixvim ./xdg.nix];

  home = {
    stateVersion = "20.09";

    sessionVariables = {
      EDITOR = "nvim";
      HOMEBREW_NO_AUTO_UPDATE = 1;
    };
    packages = with pkgs; [
      curlie
      libqalculate
      just
      jq
      mosh
      nix-index
      nix-output-monitor
      ripgrep
      rippkgs
      unixtools.watch
    ];
  };

  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      theme = "Nord";
    };
  };

  programs.eza.enable = true;

  programs.broot.enable = true;

  # Include other SSH config files that I don't want to check in here
  programs.ssh = {
    forwardAgent = true;
    includes = ["~/.ssh/config.d/*"];
  };

  # Generate rippkgs index
  xdg.dataFile."rippkgs-index.sqlite".source = let
    rippkgsIndexCmd = pkgs.runCommand "rippkgs-index" {buildInputs = [pkgs.nix];} ''
      mkdir $out
      ${pkgs.rippkgs}/bin/rippkgs-index nixpkgs -o $out/index.sqlite ${pkgs.path}
    '';
  in "${rippkgsIndexCmd}/index.sqlite";

  xdg.enable = true;
}
