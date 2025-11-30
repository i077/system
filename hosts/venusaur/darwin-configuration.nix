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
    "discord"
    "fastmail"
    "minecraft"
    "mullvad-vpn"
    "onedrive"
    "steam"
    "skim"
    "sony-ps-remote-play"
    "swiftformat-for-xcode"
    "tailscale-app"
    "the-unarchiver"
  ];

  homebrew.masApps = {
    "Bear" = 1091189122;
    "Windows App" = 1295203466;
    "Reeder." = 6475002485;
    "Things 3" = 904280696;
    WhatsApp = 310633997;
    Xcode = 497799835;
  };
}
