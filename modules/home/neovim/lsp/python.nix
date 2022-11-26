{pkgs, ...}: {
  programs.neovim = {
    extraPackages = [pkgs.nodePackages.pyright];
    lspconfig = ''
      require'lspconfig'.pyright.setup{}
    '';
  };
}
