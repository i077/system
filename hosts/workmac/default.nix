{...}: {
  imports = [
    ./brew.nix
    ./home.nix
    ./ssl.nix
    ../../modules/darwin/fish.nix
    ../../modules/darwin/1password.nix
  ];

  # User config
  users.users.hossaini.home = "/Users/hossaini";

  # Enable x86 builds
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
