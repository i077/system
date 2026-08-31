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
    "copilot-money"
    "cryptomator"
    "discord"
    "fastmail"
    "fuse-t"
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
    "1Password for Safari" = 1569813296;
    "Bear" = 1091189122;
    "Kagi for Safari" = 1622835804;
    Sofa = 1276554886;
    "StopTheMadness Pro" = 6471380298;
    "Things 3" = 904280696;
    Weathergraph = 1501958576;
    "Windows App" = 1295203466;
    WhatsApp = 310633997;
    Unread = 1363637349;
    Unwatched = 6477287463;
    "uBlock Origin Lite" = 6745342698;
    Xcode = 497799835;
  };
}
