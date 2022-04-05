{ pkgs, lib, ... }: {
  home-manager.users.imran = {
    imports = [
      ../../modules/home
      ../../modules/home/fish.nix
      ../../modules/home/direnv.nix
      ../../modules/home/fzf.nix
      ../../modules/home/git.nix
      ../../modules/home/neovim
    ];

    programs.git.userEmail = lib.mkForce ("imran.hossain" + "@" + "saic.com");

    home.packages = with pkgs; [ awscli2 ];
  };
}
