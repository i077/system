{pkgs, ...}: {
  nix.package = pkgs.nixVersions.latest;

  nix.settings = {
    # Add other binary caches
    substituters = ["https://i077.cachix.org" "https://nix-community.cachix.org/"];
    trusted-public-keys = [
      "i077.cachix.org-1:v28tOFUfUjtVXdPol5FfEO/6wC/VKWnHkD32/aMJJBk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Use nix flakes for local flake evaluation
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    builders-use-substitutes = true
  '';
}
