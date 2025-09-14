-- Get the full path to your nvim configuration
local config_dir = vim.fn.stdpath("config")

-- Add it to the runtimepath
vim.opt.rtp:prepend(config_dir)

require("config.globals")
require("config.options")
require("config.keymap")
require("config.autocmd")
require("config.lsp")

-- Lazy bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.keymap.set("n", "<leader>lu", function()
	print("Got the funky key")
end, { desc = "Mark's: Funky key" })

-- Define a new user-defined command called 'MyGreet'
vim.api.nvim_create_user_command("MyGreet", function()
	-- This is the code that runs when you execute the command
	print("Hello from a user-defined Lua command!")
end, {
	desc = "Marks Simple Command which does not take any arguments",
}) -- The empty table is for options

-- Define a command that takes one argument
vim.api.nvim_create_user_command("MyEcho", function(opts)
	-- The arguments are in the 'args' field of the options table
	-- 'opts' also contains other information like 'bang' and 'mods'
	print("You typed: " .. opts.args)
end, {
	-- 'nargs=1' means the command requires exactly one argument
	nargs = 1,
	desc = "Marks command which echos a single argument to the command line.",
})

-- print("After Lazy bootstrap")

-- Load plugins from lua/plugins/
require("lazy").setup("plugins", {
	-- Tell lazy.nvim to use a writable location for its lock file
	-- This path should be in a user-writable directory like ~/.cache or ~/.local/share
	lockfile = vim.fn.stdpath("cache") .. "/lazy-lock.json",
})

-- print("After Load")

-- Setup LSP
-- local lspconfig = require('lspconfig')
-- lspconfig.pyright.setup {}
-- require'nvim-treesitter.configs'.setup { highlight = { enable = true } }
-- require('telescope').setup{}
-- lspconfig.ts_ls.setup{}
