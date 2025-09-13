local null_ls = require("null-ls")
-- Wrap our cleanup command
local function nix_cleanup_action(params)
  local file = params.bufname
  if not file:match("%.nix$") then
    return
  end
-- Run alejandra, statix, deadnix in sequence
  local cmds = {
    "alejandra " .. vim.fn.shellescape(file),
    "statix fix " .. vim.fn.shellescape(file),
    "deadnix --edit " .. vim.fn.shellescape(file),
  }
for _, cmd in ipairs(cmds) do
    vim.fn.system(cmd)
  end
-- Reload buffer after edits
  vim.api.nvim_command("edit")
  vim.notify("✅ Nix Cleanup applied", vim.log.levels.INFO)
end
return null_ls.register({
  name = "nix_cleanup",
  method = null_ls.methods.CODE_ACTION,
  filetypes = { "nix" },
  generator = {
    fn = function(_)
      return {
        {
          title = "Nix Cleanup (alejandra + statix + deadnix)",
          action = nix_cleanup_action,
        },
      }
    end,
  },
})
