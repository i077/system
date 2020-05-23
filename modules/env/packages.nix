{ config, lib, pkgs, ... }:

{
  # ADB stuff
  programs.adb.enable = true;
  services.udev.packages = with pkgs; [ android-udev-rules ];

  environment.systemPackages = with pkgs; [
    acpi
    binutils
    file
    freetype
    gdb
    gitFull
    htop
    keybase-gui
    libsecret
    neovim
    nix-index
    openconnect
    patchelf
    pciutils
    pkg-config
    psmisc
    my-python3Full
    powertop
    qt5.qtbase
    rclone
    ripgrep
    unzip
    wget

    manpages
    stdmanpages
  ];

  home-manager.users.imran.programs = {
    bat.enable = true;
    man.enable = true;
  };

  home-manager.users.imran.home.packages = with pkgs;
    [
      # Command-line utilities
      ctags
      exa
      gnumake
      hugo
      ix
      jq
      lynx
      maim
      neuron
      niv
      openfortivpn
      pandoc
      passff-host
      pinentry-gtk2
      ranger
      tomb
      neovim-remote
      xdotool
      xsel

      # Apps
      android-studio
      brscan4
      lazygit
      libreoffice-fresh
      standardnotes
      sublime-merge
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional
      qalculate-gtk
      quodlibet-full
      todoist-electron
      typora
      pinta
      vlc
      vscode-with-extensions
      write_stylus
      zotero

      # Games
      minecraft

      # Languages & frameworks
      dart
      jdk14
      nixfmt
      texlive.combined.scheme-full
      texlab

      # Fonts
      corefonts # Microsoft core fonts for Web
      fira
      fira-code
      fira-mono
      iosevka
      nerdfonts-iosevka
      inter-ui
      jetbrains-mono
      latinmodern-math
      open-sans
      roboto
      roboto-mono
      source-code-pro
      source-sans-pro
      source-serif-pro
      ubuntu_font_family
    ]
    # Add fonts set in theming config
    ++ (lib.mapAttrsToList (_: v: v.pkg) config.theming.fonts);
}
