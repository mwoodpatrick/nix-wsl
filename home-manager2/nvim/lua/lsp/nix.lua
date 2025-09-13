return function(lspconfig, default_config)
  lspconfig.nil_ls.setup(vim.tbl_extend("force", default_config, {
    settings = {
      ["nil"] = {
        formatting = { command = { "alejandra" } },
      },
    },
  }))
end
