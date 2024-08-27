{
  pkgs,
  lib,
  ...
}: {
  home-manager.users.hossaini = {
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

    home.packages = with pkgs; [awscli2 colima docker terraform ssm-session-manager-plugin];

    # Add completions for docker
    xdg.configFile."fish/completions/docker.fish".source = "${pkgs.docker.src}/contrib/completion/fish/docker.fish";
  };
}
