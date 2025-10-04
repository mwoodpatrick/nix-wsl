return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("telescope").setup({
      defaults = {
        prompt_prefix = "  ",
        selection_caret = " ",
      },
    })
  end,
}
