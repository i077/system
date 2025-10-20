{
  config,
  inputs,
  lib,
  pkgs,
  perSystem,
  ...
}: {
  lib.env.isCi = false;

  system.stateVersion = 4;

  # macOS Sequoia requires using a new set of user/group IDs for nixbld users
  ids.gids.nixbld = 350;

  nix = {
    package = pkgs.nixVersions.latest;

    settings = {
      # Add administrators to trusted users
      trusted-users = ["@admin"];

      # Enable flakes
      experimental-features = ["nix-command" "flakes"];

      build-users-group = "nixbld";

      builders-use-substitutes = true;

      # Allow building x86 macOS packages
      extra-platforms = ["x86_64-darwin" "aarch64-darwin"];

      # Add other binary caches
      substituters = ["https://i077.cachix.org" "https://nix-community.cachix.org/"];
      trusted-public-keys = [
        "i077.cachix.org-1:v28tOFUfUjtVXdPol5FfEO/6wC/VKWnHkD32/aMJJBk="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Add inputs to registry & nix path
    nixPath = lib.mkForce [
      "nixpkgs=${inputs.nixpkgs}"
      "home-manager=${inputs.home-manager}"
      "darwin=${inputs.nix-darwin}"
    ];
    registry = let
      # Helper to copy a list of given flake inputs to the registry
      copyFlakeInputs = inputList:
        lib.genAttrs inputList (name: {
          from = {
            id = name;
            type = "indirect";
          };
          flake = inputs.${name};
        });
    in
      copyFlakeInputs ["self" "nixpkgs" "nix-darwin" "home-manager"];
  };

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [coreutils obsidian];

  # Fonts
  fonts.packages =
    if config.lib.env.isCi
    then []
    else [perSystem.self.berkeley-mono];

  # Configure home-manager
  home-manager.backupFileExtension = "bak";
}
