{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  selfPkgs = inputs.self.packages.${config.nixpkgs.system};
in {
  imports = [./brew.nix ../broken-overlay.nix ../nix-settings.nix];

  system.stateVersion = 4;

  # macOS Sequoia requires using a new set of user/group IDs for nixbld users
  ids.gids.nixbld = 350;

  nix = {
    # Enable flakes
    extraOptions = ''
      build-users-group = nixbld
      max-jobs = auto
    '';

    settings = {
      # Add administrators to trusted users
      trusted-users = ["@admin"];
    };

    # Add inputs to registry & nix path
    nixPath = lib.mkForce [
      "nixpkgs=${inputs.nixpkgs-darwin}"
      "home-manager=${inputs.home-manager}"
      "darwin=${inputs.darwin}"
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
      {
        nixpkgs = {
          from = {
            id = "nixpkgs";
            type = "indirect";
          };
          flake = inputs.nixpkgs-darwin;
        };
      }
      // copyFlakeInputs ["self" "darwin" "home-manager"];
  };

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [coreutils obsidian];

  # Fonts
  fonts.packages =
    if config.lib.env.isCi
    then []
    else [selfPkgs.berkeley-mono];

  # Enable home-manager
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };
}
