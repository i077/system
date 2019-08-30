{ config, pkgs, ... }:

let
  unstable = import <unstable> {
    config.allowUnfree = true;
  };
  custompkgs = import ../packages {};
in
{
  imports = [
    ./fish.nix
    ./git.nix
    ./gnome.nix
    ./neovim.nix
    ./tmux.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Allow unfree software
  nixpkgs.config = {
    allowUnfree = true;
  };

  # User packages
  home.packages = with unstable; [
    # Command-line utilities
    bat
    exa
    fortune
    fzf
    gitAndTools.gita
    gopass
    pass
    pandoc
    python3Packages.powerline
    tmuxPlugins.resurrect
    tectonic
    todoist
    neovim-remote

    # Apps
    android-studio
    brscan4
    gitg
    standardnotes
    sublime-merge
    qt5.qtbase

    # Languages
    dart

    # Fonts
    iosevka
    inter-ui
    roboto
    roboto-mono

    # Python packages
    python3Packages.pylint
    pipenv

    # Node packages
    nodePackages.neovim

    # GNOME Shell extensions
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.gsconnect
    gnomeExtensions.mediaplayer
  ] ++ 
  # Custom packages from above (defined in ./packages/)
  [
    custompkgs.budspencer

    custompkgs.gnomeExtensions.paperwm 
    custompkgs.gnomeExtensions.timepp
    custompkgs.gnomeExtensions.switcher

    custompkgs.write_stylus
  ];

  # Alacritty
  programs.alacritty = {
    enable = true;
    settings = {
      window.decorations = "none";
      background_opacity = 0.8;
      font.normal.family = "Iosevka";
      font.bold.family = "Iosevka";
      font.italic.family = "Iosevka";
    };
  };

  # Todoist config
  home.file.".todoist.config.json".text = ''
    {
      "token": "${builtins.readFile ../secrets/todoist_api_token}",
      "color": "true"
    }
  '';

  # Zathura
  programs.zathura = {
    enable = true;
  };

  # Fonts
  fonts.fontconfig.enable = true;
}
