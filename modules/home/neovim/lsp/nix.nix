{pkgs, ...}: {
  programs.neovim = {
    extraPackages = [pkgs.nil];
    lspconfig = ''
      require'lspconfig'.nil_ls.setup{}
    '';
  };
}
