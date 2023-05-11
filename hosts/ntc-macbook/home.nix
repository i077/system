{
  pkgs,
  lib,
  ...
}: {
  home-manager.users.imran = {
    imports = [
      ../../modules/home
      ../../modules/home/fish.nix
      ../../modules/home/direnv.nix
      ../../modules/home/fzf.nix
      ../../modules/home/git.nix
      ../../modules/home/k8s.nix
      ../../modules/home/neovim
      ../../modules/home/1password.nix
    ];

    programs.git = {
      lfs.enable = true;
      userEmail = lib.mkForce ("imran.hossain" + "@" + "saic.com");
    };

    home.packages = with pkgs; [awscli2 nodejs-19_x];
  };
}
