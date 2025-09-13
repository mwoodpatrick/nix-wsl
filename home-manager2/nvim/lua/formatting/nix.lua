local null_ls = require("null-ls")
return {
  -- Formatter
  null_ls.builtins.formatting.alejandra,
-- Diagnostics
  null_ls.builtins.diagnostics.statix,
  null_ls.builtins.diagnostics.deadnix,
}
