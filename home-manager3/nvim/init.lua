
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

opt.expandtab = true -- Neovim will never insert a hard tab (\t).
opt.tabstop = 2 -- A hard tab character (\t) is rendered as 2 spaces. It is purely a display setting

if is_wsl then
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

print("init.lua loaded")
print(vim.fn.stdpath("data"))
