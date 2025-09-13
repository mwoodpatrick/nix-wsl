return function(lspconfig, default_config)
  lspconfig.lua_ls.setup(vim.tbl_extend("force", default_config, {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
      },
    },
  }))
end
