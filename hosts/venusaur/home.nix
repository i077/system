{...}: {
  home-manager.users.imran = {
    imports = [
      ../../modules/home
      ../../modules/home/fish.nix
      ../../modules/home/direnv.nix
      ../../modules/home/fzf.nix
      ../../modules/home/git.nix
      ../../modules/home/neovim
      ../../modules/home/1password.nix
    ];
  };
}
