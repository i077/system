{ config, pkgs, ... }:

let
  unstable = import <unstable> {
    config.allowUnfree = true;
  };
  custompkgs = import ../packages {};
in
{
  imports = with builtins;
    map (name: ./configurations + "/${name}") (attrNames (readDir ./configurations));

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
    ubuntu_font_family

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
    gnomeExtensions.night-theme-switcher
    equilux-theme
    pantheon.elementary-icon-theme
    pantheon.elementary-gtk-theme
    pantheon.elementary-sound-theme
  ] ++ 
  # Custom packages from above (defined in ./packages/)
  [
    custompkgs.budspencer

    custompkgs.gnomeExtensions.paperwm 
    custompkgs.gnomeExtensions.timepp
    custompkgs.gnomeExtensions.switcher

    custompkgs.write_stylus
  ];

  # Enabled programs and services (respective configs are in ./configurations)
  programs.alacritty.enable = true;
  programs.fish.enable = true;
  programs.git.enable = true;
  programs.password-store.enable = true;
  programs.tmux.enable = true;
  programs.zathura.enable = true;

  services.lorri.enable = true;

  home.file.".config/kitty/kitty.conf".source = ./kitty.conf;

  # Todoist config
  home.file.".todoist.config.json".text = ''
    {
      "token": "${builtins.readFile ../secrets/todoist_api_token}",
      "color": "true"
    }
  '';

  # Fonts
  fonts.fontconfig.enable = true;
}
