-- Get the full path to your nvim configuration
local config_dir = vim.fn.stdpath("config")

-- Add it to the runtimepath
vim.opt.rtp:prepend(config_dir)

require("config.options")

require('config.lazy')

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = function(args)
    vim.lsp.start({
      name = "clangd",
      cmd = { vim.fn.expand("~/.nix-profile/bin/clangd") },
      root_dir = vim.fs.root(args.buf, { "compile_commands.json", ".git" }),
    })
  end,
})
