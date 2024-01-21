{pkgs, ...}: {
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

    home.packages = with pkgs; [jetbrains.idea-community];

    # Take advantage of that 120Hz screen in neovide
    programs.neovim.extraConfig = ''
      if exists('g:neovide')
        let g:neovide_refresh_rate=120
      endif
    '';
  };
}
