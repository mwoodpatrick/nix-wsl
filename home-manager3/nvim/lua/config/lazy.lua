
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
