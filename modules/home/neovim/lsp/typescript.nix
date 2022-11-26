{pkgs, ...}: {
  programs.neovim = {
    extraPackages = with pkgs.nodePackages; [typescript typescript-language-server];
    lspconfig = ''
      require'lspconfig'.tsserver.setup{}
    '';
  };
}
