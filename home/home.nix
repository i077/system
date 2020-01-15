{ config, pkgs, ... }:

{
  imports = with builtins;
    map (name: ./modules + "/${name}") (attrNames (readDir ./modules)) ++
    map (name: ./configurations + "/${name}") (attrNames (readDir ./configurations));

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  nixpkgs.config = import ../nixpkgs-config.nix;
  nixpkgs.overlays = import ../overlays;

  # User packages
  home.packages = with pkgs; [
    # Command-line utilities
    python3Packages.black
    ctags
    exa
    gnumake
    gopass
    hugo
    pandoc
    passff-host
    pinentry
    pipenv
    pypi2nix
    ranger
    todoist
    tomb
    neovim-remote
    xsel

    # Apps
    android-studio
    brscan4
    gnome3.geary
    libreoffice-fresh
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
    write_stylus
    zotero

    # Games
    minecraft

    # Languages
    dart
    texlive.combined.scheme-full
    texlab

    # Fonts
    corefonts # Microsoft core fonts for Web
    iosevka nerdfonts-iosevka
    inter-ui
    roboto roboto-mono
    ubuntu_font_family

    # Python packages
    python3Packages.powerline
    python3Packages.pylint

    # Node packages
    nodePackages.neovim

    # GTK
    equilux-theme
    pantheon.elementary-icon-theme
    pantheon.elementary-gtk-theme
    pantheon.elementary-sound-theme
  ];

  # Enabled programs and services (respective configs are in ./configurations)
  programs.alacritty.enable = true;
  programs.bat.enable = true;
  programs.direnv.enable = true;
  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.fzf.enable = true;
  programs.git.enable = true;
  programs.man.enable = true;
  programs.neovim.enable = true;
  programs.password-store.enable = true;
  programs.tmux.enable = true;
  programs.zathura.enable = true;

  systemd.user.startServices = true;
  services.gpg-agent.enable = true;
  services.lorri.enable = true;
  services.onedrive.enable = true;
  services.udiskie.enable = true;

  xsession.enable = true;
  xsession.windowManager.i3.enable = true;

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
