{flake, ...}: {
  imports = [
    flake.homeModules.default
    flake.homeModules.direnv
    flake.homeModules.fish
    flake.homeModules.fzf
    flake.homeModules.git
    flake.homeModules.ghostty
    flake.homeModules.k8s
    flake.homeModules.music
    flake.homeModules.neovim
    flake.homeModules.onepassword
    flake.homeModules.ptpython
    flake.homeModules.xdg
  ];
}
