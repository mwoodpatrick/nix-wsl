return function(lspconfig, default_config)
  -- Example: bash and json always enabled
  lspconfig.bashls.setup(default_config)
  lspconfig.jsonls.setup(default_config)
end
