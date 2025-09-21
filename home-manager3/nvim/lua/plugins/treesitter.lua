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
      incremental_selection = { 
        enable = true,
        keymaps = {
          init_selection = "<Leader>ss", -- set to `false` to disable one of the mappings
          node_incremental = "<Leader>si",
          scope_incremental = "<Leader>sc",
          node_decremental = "<Leader>sd",
        },
      },

      textobjects = {
        -- enable = true, 
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            -- You can also use captures from other query groups like `locals.scm`
            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
          },
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true or false
          include_surrounding_whitespace = true,
        },
      },
    })
  end
}
