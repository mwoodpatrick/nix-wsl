
-- options

local opt = vim.opt  -- to set options
local is_wsl = vim.env.WSL_DISTRO_NAME ~= nil

-- Relative and absolute line numbers combined
-- [indentation](https://neovim.io/doc/user/indent.html)
opt.number = true -- Enable line numbers
opt.relativenumber = true -- Enable relative line numbers

-- Window splitting
opt.splitright = true
opt.splitbelow = true

opt.wrap = false -- Disable line wrapping

-- Tabstops
-- [indentation](https://neovim.io/doc/user/indent.html)
-- and how many spaces are deleted when you press the <BS> (backspace) key.
-- Pressing <Tab> will insert softtabstop spaces.
-- Commands that indent (like >>) will insert shiftwidth spaces.
opt.expandtab = true -- Neovim will never insert a hard tab (\t).
opt.tabstop = 2 -- A hard tab character (\t) is rendered as 2 spaces. It is purely a display setting
opt.shiftwidth = 2 -- Used by the auto-indent feature when you press <CR> (Enter) enters 2 spaces
opt.softtabstop = 2 -- Defines how many spaces are inserted when you press the <Tab> key in Insert mode

opt.scrolloff = 999

opt.virtualedit = "block"

-- Preview substitutions
opt.inccommand = "split"

-- Search
opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true -- Enable 24-bit RGB colors

-- Synchronize the system clipboard
-- with Neovim's clipboard
if is_wsl then
  -- Integrate with the Windows clipboard.
  -- Use win32yank when running on WSL
  vim.g.clipboard = {
    name = 'win32yank',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
else
  -- Use a standard clipboard manager for other Linux systems
  opt.clipboard = 'unnamedplus'
end

-- Sets up lazy.nvim

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

-- print("init.lua loaded")
-- print(vim.fn.stdpath("data"))

-- Load plugins from lua/plugins/
require("lazy").setup("plugins", {
-- require("lazy").setup({
	-- Tell lazy.nvim to use a writable location for its lock file
	-- This path should be in a user-writable directory like ~/.cache or ~/.local/share
	lockfile = vim.fn.stdpath("cache") .. "/lazy-lock.json",
  -- "rebelot/kanagawa.nvim"
})

vim.cmd.colorscheme("kanagawa-wave")
