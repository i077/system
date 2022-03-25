{ inputs, pkgs, ... }:

{
  imports = [ ./pam.nix ./brew.nix ];

  # Enable flakes
  nix.extraOptions = ''
    build-users-group = nixbld
    auto-optimise-store = true
    experimental-features = nix-command flakes
    max-jobs = auto
  '';

  # Add administrators to trusted users
  nix.trustedUsers = [ "@admin" ];
  users.nix.configureBuildUsers = true;

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
