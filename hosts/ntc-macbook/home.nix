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
      ../../modules/home/neovim
      ../../modules/home/1password.nix
    ];

    programs.git = {
      lfs.enable = true;
      userEmail = lib.mkForce ("imran.hossain" + "@" + "saic.com");
    };

    home.packages = with pkgs; [awscli2 nodePackages.pnpm nodejs-16_x kubectl kubernetes-helm eksctl fluxcd];

    # k9s at work
    programs.k9s.enable = true;
  };
}
