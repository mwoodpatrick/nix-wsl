
-- https://mitchellt.com/2022/05/15/WSL-Neovim-Lua-and-the-Windows-Clipboard.html

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

-- if in_wsl then
--     vim.g.clipboard = {
--         name = 'wsl clipboard',
--         copy =  { ["+"] = { "clip.exe" },   ["*"] = { "clip.exe" } },
--         paste = { ["+"] = { "nvim_paste" }, ["*"] = { "nvim_paste" } },
--         cache_enabled = true
--     }
-- end

-- vim.g.clipboard = {
--     name = "win32yank-wsl",
--     copy = {
--         ["+"] = "win32yank.exe -i --crlf",
--         ["*"] = "win32yank.exe -i --crlf",
--     },
--     paste = {
--         ["+"] = "win32yank.exe -o --lf",
--         ["*"] = "win32yank.exe -o --lf",
--     },
--     cache_enabled = true,
-- }
--
