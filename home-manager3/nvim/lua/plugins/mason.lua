return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup()

		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = {
				"cssls",
				"eslint",
				"html",
				"jsonls",
				"ts_ls",
				"pyright",
				"tailwindcss",
				"gopls",
				"golangci_lint_ls",
			},
      handlers = {
        function(server_name)
            require("lspconfig")[server_name].setup {}
        end,

        ['lua_ls'] = function()
           print("Lua in Mason") 
            lspconfig.lua_ls.setup {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' },
                        },
                    },
                },
            }
        end,

        ["pyright"] = function()
          print("pyright in Mason")
				  -- nvim_lsp["pyright"].setup({
					-- on_attach = on_attach,
					-- capabilities = capabilities,
				  -- })
		    end,

        
        },
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettier",
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint",
				"eslint_d",
			},
		})
	end,
}
