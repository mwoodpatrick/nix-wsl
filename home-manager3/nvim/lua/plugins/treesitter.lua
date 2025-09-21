-- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/tree/main)
return {
  'nvim-treesitter/nvim-treesitter',

  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    local configs = require("nvim-treesitter.configs")
    ---@diagnostic disable-next-line: missing-fields
    configs.setup({
      -- A list of parser names, or "all" (the listed parsers MUST always be installed)
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "nix" },
      
      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      -- The auto_install setting will actually automatically install any missing parsers 
      -- when opening a file for the first time. 
      -- So if you don’t have rust listed in the ensure_installed, 
      -- it will be automatically installed when you open a rust file for the first time

      auto_install = { enable = true },

      -- enable syntax highlighting
      highlight = { enable = true, },

      -- enable indentation
      indent = { enable = true },

      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = { enable = true },

      -- enable incremental selection
      incremental_selection = { enable = true },
    })
  end
}
