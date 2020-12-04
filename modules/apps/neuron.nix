{ config, lib, pkgs, ... }:

{
  # Add package
  home-manager.users.imran.home.packages = with pkgs; [
    neuron

    # Dependencies of vim plugin
    fzf
    ripgrep
    jq
  ];

  # Add vim plugin
  home-manager.users.imran.programs.neovim.plugins =
    lib.mkIf config.home-manager.users.imran.programs.neovim.enable [ pkgs.vimPlugins.neuron-vim ];
}
