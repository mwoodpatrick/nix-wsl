local M = {}
function M.cleanup()
  local file = vim.fn.expand("%:p")
  if vim.bo.filetype ~= "nix" then
    print("⛔ Not a Nix file")
    return
  end
-- Define commands
  local cmds = {
    "alejandra " .. vim.fn.shellescape(file),
    "statix fix " .. vim.fn.shellescape(file),
    "deadnix --edit " .. vim.fn.shellescape(file),
  }
-- Run them in sequence
  for _, cmd in ipairs(cmds) do
    vim.fn.jobstart(cmd, {
      stdout_buffered = true,
      stderr_buffered = true,
      on_stdout = function(_, data)
        if data then
          print(table.concat(data, "\n"))
        end
      end,
      on_stderr = function(_, data)
        if data then
          print(table.concat(data, "\n"))
        end
      end,
    })
  end
-- Reload buffer
  vim.cmd("edit")
  print("✅ Nix Cleanup applied")
end
return M
