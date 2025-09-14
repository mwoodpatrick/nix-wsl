-- See: 
--    https://gpanders.com/blog/whats-new-in-neovim-0-11/
--    https://github.com/neovim/nvim-lspconfig
-- Enable with vim.lsp.enable({'clangd', 'gopls', 'rust-analyzer', 'lua-ls'})
return {
  cmd = { 'clangd', '--background-index' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt' },
  filetypes = { 'c', 'cpp' },
}
