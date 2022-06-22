require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = vim.g.vscode == nil,
    disable = {"latex"} -- vimtex is good enough
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm"
    }
  },
  indent = {
    enable = true,
    disable = {"lua", "python"} -- Broken for these languages
  }
}

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
