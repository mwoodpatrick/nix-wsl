-- Modern Neovim 0.12+ compatible logger module
local M = {}
-- Default log file (in Neovim’s state dir)
local log_file = vim.fn.stdpath("state") .. "/nvim_debug.log"

-- Timestamp helper
local function ts()
  return os.date("%Y-%m-%d %H:%M:%S")
end
-- Core write function
local function write(level, msg)
  local file = io.open(log_file, "a")
  if not file then return end
  file:write(string.format("[%s] [%s] %s\n", ts(), level, msg))
  file:close()
end
-- Level names from vim.log.levels
local levels = vim.log.levels
-- Public logging methods
function M.trace(msg)  write("TRACE", msg) end
function M.debug(msg)  write("DEBUG", msg) end
function M.info(msg)   write("INFO",  msg) end
function M.warn(msg)   write("WARN",  msg) end
function M.error(msg)  write("ERROR", msg) end
-- Neovim message display (optional)
function M.notify(msg, level)
  level = level or levels.INFO
  vim.notify(msg, level, { title = "Logger" })
  local label = vim.tbl_keys(levels)[level + 1] or "INFO"
  write(label, msg)
end
-- Configure custom path or rotation
function M.setup(opts)
  opts = opts or {}
  if opts.file then
    log_file = opts.file
  end
  if opts.clear then
    os.remove(log_file)
  end
  write("INFO", "Logger initialized")
end
-- Expose current log path
function M.path()
  return log_file
end
return M
