{ ... }: {
  home-manager.users.imran = { imports = [ ../../modules/home ../../modules/home/fish.nix ]; };
}
