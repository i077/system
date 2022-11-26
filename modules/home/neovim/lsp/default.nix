# The way I'm managing LSP configuration via home-manager's neovim module is a bit... weird. I want
# all the resulting Lua config snippets for the nvim-lspconfig to be close to each other, but the
# config for each language should be in its own separate file. So I'm declaring
# a new option here that will gather all those lua snippets and place them in a plugin block for
# nvim-lspconfig, which will go in the programs.neovim.plugins option.
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkBefore mkOption types;

  cfg = config.programs.neovim.lspconfig;
in {
  options.programs.neovim.lspconfig = mkOption {
    description = ''
      Lua configuration for the nvim-lspconfig plugin. Used to gather all lsp-related configuration
      across different files so code can be re-used.
    '';
    type = types.lines;
  };

  config = {
    programs.neovim = {
      # Add lspconfig with all gathered configuration
      plugins = [
        {
          plugin = pkgs.vimPlugins.nvim-lspconfig;
          type = "lua";
          config = cfg;
        }
      ];

      # Add defaults, which will go before all other language-specific config
      lspconfig = mkBefore "";
    };
  };

  # Import language-specific configs
  imports = [./lua.nix ./nix.nix ./python.nix ./terraform.nix ./typescript.nix];
}
