vim.o.number = true -- Enable line numbers
-- vim.o.relativenumber = true -- Enable relative line numbers
-- [indentation](https://neovim.io/doc/user/indent.html)
vim.o.tabstop = 2 -- A hard tab character (\t) is rendered as 2 spaces. It is purely a display setting
vim.o.shiftwidth = 2 -- Used by the auto-indent feature when you press <CR> (Enter) enters 2 spaces
vim.o.softtabstop = 2 -- Defines how many spaces are inserted when you press the <Tab> key in Insert mode
-- and how many spaces are deleted when you press the <BS> (backspace) key.
vim.o.expandtab = true -- Neovim will never insert a hard tab (\t).
-- Pressing <Tab> will insert softtabstop spaces.
-- Commands that indent (like >>) will insert shiftwidth spaces.
vim.o.smartindent = true -- general-purpose indentation behavior that works well for many
-- C-like languages without needing complex, language-specific rules.
-- • Copy the Previous Line's Indentation: Like autoindent, it automatically carries over the indentation from the previous line when you press <CR> (Enter).
-- • Indenting After a Brace {: It intelligently adds an extra level of indentation after you type an opening curly brace {. This is useful for languages like C, C++, Java, JavaScript, etc.
-- • Un-indenting After a Brace }: When you type a closing curly brace } on a new line, it automatically reduces the indentation to match the level of the corresponding opening {.
-- • Indenting After Control Structures: It often provides an extra indentation after keywords like for, if, while, or else, particularly in C-style languages.
-- • Continuing Comments: It keeps the same indentation for subsequent lines within a multi-line comment.
vim.o.wrap = false -- Disable line wrapping
vim.o.cursorline = true -- Highlight the current line
vim.o.termguicolors = true -- Enable 24-bit RGB colors

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
