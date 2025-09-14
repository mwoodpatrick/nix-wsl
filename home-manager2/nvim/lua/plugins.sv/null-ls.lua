return {
  "nvimtools/none-ls.nvim", -- null-ls has moved here
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("formatting") -- loads lua/formatting/init.lua
  end,
}
