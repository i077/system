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
    ctags
    direnv
    exa
    fortune
    fzf
    gitAndTools.gita
    gnumake
    gopass
    python3Packages.black
    pandoc
    passff-host
    pipenv
    pypi2nix
    tmuxPlugins.resurrect
    todoist
    tomb
    neovim-remote
    xsel

    # Apps
    android-studio
    brscan4
    gnome3.geary
    gitg
    kitty
    libreoffice-fresh
    nasc
    rhythmbox
    standardnotes
    sublime-merge
    jetbrains.idea-community
    jetbrains.pycharm-community
    qalculate-gtk
    qt5.qtbase
    gnome3.sushi
    typora
    pinta
    vlc
    vscode-with-extensions
    zotero

    # Games
    minecraft

    # Languages
    dart
    texlive.combined.scheme-full
    texlab

    # Fonts
    iosevka
    inter-ui
    roboto
    roboto-mono

    # Python packages
    python3Packages.powerline
    python3Packages.pylint

    # Node packages
    nodePackages.neovim

    # GNOME Shell extensions
    gnomeExtensions.dash-to-dock
    gnomeExtensions.gsconnect
    gnomeExtensions.mpris-indicator-button
    gnomeExtensions.topicons-plus
    equilux-theme
    pantheon.elementary-icon-theme
  ] ++ 
  # Custom packages from above (defined in ./packages/)
  [
    custompkgs.budspencer

    custompkgs.gnomeExtensions.paperwm 
    custompkgs.gnomeExtensions.timepp
    custompkgs.gnomeExtensions.switcher

    custompkgs.write_stylus
  ];

  services.lorri.enable = true;

  # Password Store
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "/home/imran/.password-store";
    };
  };

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
