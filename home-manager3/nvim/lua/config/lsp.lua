-- lsp
--------------------------------------------------------------------------------
-- [Lsp](https://neovim.io/doc/user/lsp.html)
-- [What's New in Neovim 0.11](https://gpanders.com/blog/whats-new-in-neovim-0-11/) for a nice overview
-- of how the lsp setup works in neovim 0.11+.
-- [Configuring Neovim 0.11 LSP from scratch](https://blog.diovani.com/technology/2025/06/13/configuring-neovim-011-lsp.html)
-- [Neovim LSP 0.11](https://davelage.com/posts/neovim-lsp-0.11/)
-- [Native LSP config in Neovim V0.11](https://0xunicorn.com/neovim-native-lsp-config/)
-- [LSP Configuration in Neovim 0.11[(https://goral.net.pl/post/lsp-configuration-in-neovim-011/)
-- This actually just enables the lsp servers.
-- The configuration is found in the lsp folder inside the nvim config folder,
-- so in ~.config/lsp/lua_ls.lua for lua_ls, for example.
vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('nil')
vim.lsp.enable('pylsp')

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end)
    end
  end,
})

-- Diagnostics
vim.diagnostic.config({
  -- Use the default configuration
  -- virtual_lines = true

  -- Alternatively, customize specific options
  virtual_lines = {
    -- Only show virtual line diagnostics for the current cursor line
    current_line = true,
  },
})
