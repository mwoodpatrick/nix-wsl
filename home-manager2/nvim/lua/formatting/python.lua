local null_ls = require("null-ls")
return {
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.isort,
  null_ls.builtins.diagnostics.flake8,
}
