{ ... }: {
  home-manager.users.imran = {
    imports = [
      ../../modules/home
      ../../modules/home/fish.nix
      ../../modules/home/direnv.nix
      ../../modules/home/fzf.nix
      ../../modules/home/git.nix
    ];
    
    programs.broot.enable = true;
  };
}
