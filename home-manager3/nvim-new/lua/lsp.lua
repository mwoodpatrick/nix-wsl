-- [LSP configs](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
--
local servers = {
  bashls = {
    -- Optional: Add settings here if needed, but bashls is usually fine with defaults.
    -- Example to suppress certain diagnostics:
    settings = {
      bashls = {
        -- For example, to control the behavior of the integrated ShellCheck:
        diagnostics = {
          group = {
            -- Disable specific warnings if they clutter the screen
            -- [Example: 'MyScript/Warning_Name'] = false
          },
        },
      },
    },
  },
}

-- Loop through and enable/configure all servers
for server_name, config in pairs(servers) do
  vim.lsp.config(server_name, config)
  vim.lsp.enable(server_name)
end


vim.lsp.enable({
  -- "bashls",
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
