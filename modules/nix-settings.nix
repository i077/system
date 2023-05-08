{
  config,
  lib,
  pkgs,
  ...
}: {
  nix.package = pkgs.nixUnstable;

  nix.settings = {
    # Add other binary caches
    substituters = ["https://i077.cachix.org" "https://nix-community.cachix.org/"];
    trusted-public-keys = [
      "i077.cachix.org-1:v28tOFUfUjtVXdPol5FfEO/6wC/VKWnHkD32/aMJJBk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Add remote builders
  nix.distributedBuilds = true;
  nix.buildMachines = lib.optional (config.networking.hostName != "staryu") {
    hostName = "staryu";
    systems = ["x86_64-linux" "aarch64-linux"];
    maxJobs = 4;
    supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
  };

  # Use nix flakes for local flake evaluation
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    builders-use-substitutes = true
  '';
}
