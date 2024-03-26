{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./brew.nix ./home.nix ../../modules/darwin/fish.nix ../../modules/darwin/1password.nix];

  # User config
  users.users.hossaini.home = "/Users/hossaini";
  users.users.hossaini.shell = pkgs.fish;

  # Enable x86 builds
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
