{ pkgs, ... }: {
  programs.neovim = {
    extraPackages = [ pkgs.rnix-lsp ];
    lspconfig = ''
      require'lspconfig'.rnix.setup{}
    '';
  };
}
