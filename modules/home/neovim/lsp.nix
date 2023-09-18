{...}: {
  programs.nixvim = {
    plugins.lsp = {
      enable = true;

      servers = {
        # Nix
        nixd = {
          enable = true;
          settings = {
            formatting.command = "alejandra";
          };
        };

        # Python
        pylsp.enable = true;

        # Terraform
        terraformls.enable = true;

        # TypeScript
        tsserver.enable = true;
      };
    };
  };
}
