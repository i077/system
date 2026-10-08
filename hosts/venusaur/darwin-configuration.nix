{flake, ...}: let
  hostName = "Venusaur";
in {
  imports = [
    flake.darwinModules.default
    flake.darwinModules.brew
    flake.darwinModules.broken-overlay
    flake.darwinModules.fish
    flake.darwinModules.onepassword
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  # User config
  users.users.imran.home = "/Users/imran";
  system.primaryUser = "imran";

  networking = {
    computerName = hostName;
    inherit hostName;
  };

  # Enable touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Host specific programs
  homebrew.casks = [
    "adobe-digital-editions"
    "altserver"
    "calibre"
    "cryptomator"
    "discord"
    "fastmail"
    "fuse-t"
    "helium-browser"
    "minecraft"
    "mullvad-vpn"
    "onedrive"
    "steam"
    "skim"
    "sony-ps-remote-play"
    "tailscale-app"
    "the-unarchiver"
  ];

  homebrew.masApps = {
    Bear = 1091189122;
    Copilot = 1447330651;
    Flighty = 1358823008;
    Flyleaf = 6475200381;
    Infuse = 1136220934;
    MusicHarbor = 1440405750;
    Parcel = 375589283;
    Sofa = 1276554886;
    "Things 3" = 904280696;
    Unread = 1363637349;
    Unwatched = 6477287463;
    Weathergraph = 1501958576;
    WhatsApp = 310633997;
    "Windows App" = 1295203466;
    Xcode = 497799835;

    # Safari extensions
    "1Password for Safari" = 1569813296;
    "Dark Reader for Safari" = 1438243180;
    Litterbox = 6805719216;
    "Kagi for Safari" = 1622835804;
    "StopTheMadness Pro" = 6471380298;
    "uBlock Origin Lite" = 6745342698;
  };
}
