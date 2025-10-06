return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
    -- local lspconfig = vim.lsp.config

    vim.print("LSP config called, does nothing currently")

-- 		local protocol = require("vim.lsp.protocol")
-- 
-- 		local on_attach = function(client, bufnr)
-- 			-- format on save
-- 			if client.server_capabilities.documentFormattingProvider then
-- 				vim.api.nvim_create_autocmd("BufWritePre", {
-- 					group = vim.api.nvim_create_augroup("Format", { clear = true }),
-- 					buffer = bufnr,
-- 					callback = function()
-- 						vim.lsp.buf.format()
-- 					end,
-- 				})
-- 			end
-- 		end
-- 
-- 		local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- 
--     on_attach = function(client, bufnr)
--       -- Keybindings for LSP functionality
--       local bufopts = { noremap=true, silent=true, buffer=bufnr }
--       vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
--       vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
--       vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
--     end,

 --     lspconfig.pyright.setup({
 -- 			on_attach = on_attach,
 -- 			capabilities = capabilities,
 --     settings = {
 --       python = {
 --         analysis = {
 --           typeCheckingMode = "strict", -- Options: off, basic, strict
 --           autoSearchPaths = true,
 --           useLibraryCodeForTypes = true,
 --         },
 --       },
 --     },
 --   })

--		mason_lspconfig.setup_handlers({
--			function(server)
--				nvim_lsp[server].setup({
--					capabilities = capabilities,
--				})
--			end,
--			["ts_ls"] = function()
--				nvim_lsp["ts_ls"].setup({
--					on_attach = on_attach,
--					capabilities = capabilities,
--				})
--			end,
--			["cssls"] = function()
--				nvim_lsp["cssls"].setup({
--					on_attach = on_attach,
--					capabilities = capabilities,
--				})
--			end,
--			["tailwindcss"] = function()
--				nvim_lsp["tailwindcss"].setup({
--					on_attach = on_attach,
--					capabilities = capabilities,
--				})
--			end,
--			["html"] = function()
--				nvim_lsp["html"].setup({
--					on_attach = on_attach,
--					capabilities = capabilities,
--				})
--			end,
--			["jsonls"] = function()
--				nvim_lsp["jsonls"].setup({
--					on_attach = on_attach,
--					capabilities = capabilities,
--				})
--			end,
--			["eslint"] = function()
--				nvim_lsp["eslint"].setup({
--					on_attach = on_attach,
--					capabilities = capabilities,
--				})
--			end,
--			["gopls"] = function()
--				nvim_lsp["gopls"].setup({
--					on_attach = on_attach,
--					capabilities = capabilities,
--				})
--			end,
--			["golangci_lint_ls"] = function()
--				nvim_lsp["golangci_lint_ls"].setup({
--					on_attach = on_attach,
--					capabilities = capabilities,
--				})
--			end,
--		})

	end,
}
