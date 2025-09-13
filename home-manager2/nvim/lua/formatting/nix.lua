local null_ls = require("null-ls")
return {
  -- Formatter
  null_ls.builtins.formatting.alejandra,
  -- If you prefer nixpkgs-fmt, swap with:
  -- null_ls.builtins.formatting.nixpkgs_fmt,

-- Diagnostics
  null_ls.builtins.diagnostics.statix,
  null_ls.builtins.diagnostics.deadnix,
}
