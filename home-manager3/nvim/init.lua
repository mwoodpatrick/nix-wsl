-- Get the full path to your nvim configuration
local config_dir = vim.fn.stdpath("config")

-- Add it to the runtimepath
vim.opt.rtp:prepend(config_dir)

require("config.options")

require('config.lazy')
