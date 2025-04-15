in_wsl = os.getenv('WSL_DISTRO_NAME') ~= nil

if in_wsl then
  -- Use win32yank.exe for clipboard integration on WSL
  local win32yank_path = "/mnt/c/Users/mlwp/Downloads/win32yank-x64/win32yank.exe" -- <-- CHANGE THIS PATH
  
  if vim.fn.executable(win32yank_path) == 1 then
    vim.g.clipboard = {
      name = 'win32yank',
      copy = {
        ['+'] = win32yank_path .. ' -i --crlf',
        ['*'] = win32yank_path .. ' -i --crlf',
      },
      paste = {
        ['+'] = win32yank_path .. ' -o --lf',
        ['*'] = win32yank_path .. ' -o --lf',
      },
      cache_enabled = 1,
    }
    -- Optional: Make it the default unnamed register
    vim.opt.clipboard = 'unnamedplus'
  else
    print("win32yank.exe not found or not executable at: " .. win32yank_path)
  end
end

vim.o.tabstop = 2 -- A TAB character looks like 2 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 2 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2 -- Number of spaces inserted when indenting
