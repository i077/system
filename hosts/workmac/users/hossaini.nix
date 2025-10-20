{
  flake,
  pkgs,
  lib,
  ...
}: {
  imports = [
    flake.homeModules.default
    flake.homeModules.direnv
    flake.homeModules.fish
    flake.homeModules.fzf
    flake.homeModules.git
    flake.homeModules.ghostty
    flake.homeModules.k8s
    flake.homeModules.neovim
    flake.homeModules.onepassword
    flake.homeModules.ptpython
    flake.homeModules.xdg
  ];

  programs.git = {
    lfs.enable = true;
    userEmail = lib.mkForce ("imran.hossain" + "@" + "saic.com");
  };

  home.packages = with pkgs; [awscli2 aws-sso-cli aws-vault terraform terragrunt ssm-session-manager-plugin];
}
