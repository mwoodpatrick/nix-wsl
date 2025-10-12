-- [LSP configs](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
vim.lsp.enable({
  "bashls",
  "gopls",
  "lua_ls",
  "texlab",
  "ts_ls",
  "rust-analyzer",
  "helm_ls",
  "clangd",
  "nil",
  "yamlls",
  "pylsp",
})
vim.diagnostic.config({ virtual_text = true })
