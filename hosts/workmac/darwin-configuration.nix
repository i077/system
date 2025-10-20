{flake, ...}: {
  imports = [
    flake.darwinModules.default
    flake.darwinModules.fish
    flake.darwinModules.onepassword
    ./ssl.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  # User config
  users.users.hossaini.home = "/Users/hossaini";
  system.primaryUser = "hossaini";

  # Host specific programs
  homebrew.casks = [
    "apache-directory-studio"
    "navicat-premium"
    "slack"
  ];
}
