{pkgs, ...}: {
  programs.neovim = {
    extraPackages = [pkgs.terraform-ls];
    lspconfig = ''
      require'lspconfig'.terraformls.setup{}
    '';
  };
}
