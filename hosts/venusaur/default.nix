{...}: let
  hostName = "Venusaur";
in {
  imports = [./brew.nix ./home.nix ../../modules/darwin/fish.nix ../../modules/darwin/1password.nix];

  # User config
  users.users.imran.home = "/Users/imran";
  system.primaryUser = "imran";

  networking = {
    computerName = hostName;
    inherit hostName;
  };

  # Enable touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Enable x86 builds
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
