{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [./brew.nix ./xdg.nix ../broken-overlay.nix ../nix-settings.nix];

  nix = {
    configureBuildUsers = true;
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

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;

  environment.systemPackages = with pkgs; [coreutils obsidian];

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [input-fonts];

  # Enable home-manager
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };

  users.users.imran = {
    home = "/Users/imran";
    shell = pkgs.fish;
  };
}
