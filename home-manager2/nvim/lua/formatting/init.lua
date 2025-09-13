local null_ls = require("null-ls")
local sources = {}
vim.list_extend(sources, require("formatting.python"))
vim.list_extend(sources, require("formatting.lua"))
vim.list_extend(sources, require("formatting.nix"))

print("Skippin formatting/init.lua")
-- print(vim.inspect(sources))

-- Load the custom code action
-- table.insert(sources, require("formatting.nix_code_action"))
-- print("After final element ")
-- print(vim.inspect(sources))

-- local format_on_save = {
--   python = true,
--   lua = true,
--   nix = true,
-- }
-- _G.FORMAT_ON_SAVE_ENABLED = true
-- function _G.toggle_format_on_save()
--   FORMAT_ON_SAVE_ENABLED = not FORMAT_ON_SAVE_ENABLED
--   if FORMAT_ON_SAVE_ENABLED then
--     print("✅ Format on Save: Enabled")
--   else
--     print("⛔ Format on Save: Disabled")
--   end
-- end
-- 
-- print("Got to null_ls.setup")
-- 
-- vim.keymap.set("n", "<leader>tf", _G.toggle_format_on_save, { desc = "Toggle Format on Save" })
-- null_ls.setup({
--   sources = sources,
--   on_attach = function(client, bufnr)
--     if client.supports_method("textDocument/formatting") then
--       vim.keymap.set("n", "<leader>f", function()
--         vim.lsp.buf.format({ async = true })
--       end, { buffer = bufnr, desc = "[LSP] Format buffer" })
-- 
--       local ft = vim.bo[bufnr].filetype
--       if format_on_save[ft] then
--         vim.api.nvim_create_autocmd("BufWritePre", {
--           buffer = bufnr,
--           callback = function()
--             if FORMAT_ON_SAVE_ENABLED then
--               vim.lsp.buf.format({ bufnr = bufnr })
--             end
--           end,
--         })
--       end
--     end
--   end,
-- })
-- 
-- vim.api.nvim_create_user_command("NixCleanup", function()
--   require("formatting.nix_cleanup").cleanup()
-- end, { desc = "Run alejandra + statix + deadnix on current file" })
-- -- Optional keybinding
-- vim.keymap.set("n", "<leader>nc", "<cmd>NixCleanup<CR>", { desc = "Nix Cleanup" })


