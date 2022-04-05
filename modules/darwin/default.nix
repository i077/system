{ inputs, lib, pkgs, ... }:

{
  imports = [ ./pam.nix ./brew.nix ];

  users.nix.configureBuildUsers = true;

  # Link each input to /etc/sources
  environment.etc =
    (lib.mapAttrs' (name: value: (lib.nameValuePair "sources/${name}" { source = value; })) inputs);

  nix = {
    # Enable flakes
    extraOptions = ''
      build-users-group = nixbld
      auto-optimise-store = true
      experimental-features = nix-command flakes
      max-jobs = auto
    '';

    # Add administrators to trusted users
    trustedUsers = [ "@admin" ];

    # Add remote builders
    distributedBuilds = true;
    buildMachines = [{
      hostName = "eu.nixbuild.net";
      systems = [ "x86_64-linux" "aarch64-linux" ];
      maxJobs = 100;
      supportedFeatures = [ "benchmark" "big-parallel" ];
    }];

    # Add inputs to registry & nix path
    nixPath = lib.mkForce [
      "nixpkgs=/etc/sources/nixpkgs"
      "home-manager=/etc/sources/home-manager"
      "darwin=/etc/sources/darwin"
    ];
    registry = {
      nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        flake = inputs.nixpkgs;
      };
      darwin = {
        from = {
          id = "darwin";
          type = "indirect";
        };
        flake = inputs.darwin;
      };
    };

    # Add other binary caches
    binaryCaches = [ "https://i077.cachix.org" "https://nix-community.cachix.org/" ];
    binaryCachePublicKeys = [
      "i077.cachix.org-1:v28tOFUfUjtVXdPol5FfEO/6wC/VKWnHkD32/aMJJBk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;

  environment.systemPackages = with pkgs; [ coreutils ];

  # Enable home-manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };
}
