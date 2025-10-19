-- [Minimal Neovim config v0.12 edition](https://vieitesss.github.io/posts/Neovim-new-config/)
-- [nvim](https://github.com/vieitesss/nvim)
local config_dir = vim.fn.stdpath("config")
local state_dir = vim.fn.stdpath("state") .. "/startup_logs"

print("Using nvim config:"..config_dir.."logs:"..state_dir)
vim.fn.input("Press ENTER to acknowledge: ")
-- vim.notify("pkglog logfile:" .. log_file , vim.log.levels.INFO)

require('plugins')
require('configs')
require('keymaps')
require('autocmds')
require('statusline')
require('lsp')
