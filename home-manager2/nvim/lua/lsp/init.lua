local lspconfig = require("lspconfig")
-- Default on_attach function (keymaps, etc.)
local function on_attach(client, bufnr)
  local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end
  bufmap("n", "gd", vim.lsp.buf.definition, "[LSP] Go to definition")
  bufmap("n", "K", vim.lsp.buf.hover, "[LSP] Hover docs")
  bufmap("n", "<leader>rn", vim.lsp.buf.rename, "[LSP] Rename")

  -- Wrap code actions to always show NixCleanup
  bufmap("n", "<leader>ca", function()
    if vim.bo.filetype == "nix" then
      -- Show built-in LSP actions + null-ls ones (includes NixCleanup)
      vim.lsp.buf.code_action({
        filter = function(action)
          return true -- don’t filter, include everything
        end,
      })
    else
      vim.lsp.buf.code_action()
    end
  end, "[LSP] Code Action")
end

  bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "[LSP] Code Action")
end
-- Default capabilities (completion, etc.)
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Shared config
local default_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}
-- Load default config
require("lsp.default")(lspconfig, default_config)
-- Load language-specific configs
require("lsp.python")(lspconfig, default_config)
require("lsp.lua")(lspconfig, default_config)
require("lsp.nix")(lspconfig, default_config)
