-- Sets up lazy.nvim
-- [Getting Started](https://lazy.folke.io/)
-- [lazy.nvim](https://github.com/folke/lazy.nvim)
-- [Nerd Fonts](https://www.nerdfonts.com/)
-- [LuaRocks](https://luarocks.org/)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
	-- Tell lazy.nvim to use a writable location for its lock file
	-- This path should be in a user-writable directory like ~/.cache or ~/.local/share
	lockfile = vim.fn.stdpath("cache") .. "/lazy-lock.json",
})
