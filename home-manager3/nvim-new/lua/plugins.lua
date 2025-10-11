-- ~/.config/nvim-new/lua/plugins.lua
vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require('gitsigns').setup({ signcolumn = false })

-- ~/.config/nvim-new/lua/plugins.lua
vim.pack.add({
    { src = "https://github.com/mason-org/mason.nvim" },
})

require("mason").setup({})

-- [blink.cmp](https://cmp.saghen.dev/)
vim.pack.add({
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
})

require('blink.cmp').setup({
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
    keymap = {
        preset = "default",
        ["<C-space>"] = {},
        ["<C-p>"] = {},
        ["<Tab>"] = {},
        ["<S-Tab>"] = {},
        ["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-n>"] = { "select_and_accept" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_down", "fallback" },
        ["<C-f>"] = { "scroll_documentation_up", "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
        -- ["<C-e>"] = { "hide" },
    },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        }
    },

    cmdline = {
        keymap = {
            preset = 'inherit',
            ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
    },

    sources = { default = { "lsp" } }
})

vim.pack.add({
    { src = "https://github.com/mcauley-penney/techbase.nvim" },
})

-- require('techbase').setup({vim.cmd.colorscheme("techbase")})

-- [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)
vim.pack.add({
    { src = "https://github.com/rebelot/kanagawa.nvim" },
})

--require('kanagawa').setup({vim.cmd.colorscheme("kanagawa-wave")})
-- require('kanagawa').setup({vim.cmd.colorscheme("kanagawa-dragon")})
-- require('kanagawa').setup({vim.cmd.colorscheme("kanagawa-lotus")})
-- require("kanagawa").load("wave")
require("kanagawa").load("dragon")
-- require("kanagawa").load("lotus")

-- ~/.config/nvim-new/lua/plugins.lua
vim.pack.add({
    { src = "https://github.com/ibhagwan/fzf-lua" },
})

local actions = require('fzf-lua.actions')
require('fzf-lua').setup({
    winopts = { backdrop = 85 },
    keymap = {
        builtin = {
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
            ["<C-p>"] = "toggle-preview",
        },
        fzf = {
            ["ctrl-a"] = "toggle-all",
            ["ctrl-t"] = "first",
            ["ctrl-g"] = "last",
            ["ctrl-d"] = "half-page-down",
            ["ctrl-u"] = "half-page-up",
        }
    },
    actions = {
        files = {
            ["ctrl-q"] = actions.file_sel_to_qf,
            ["ctrl-n"] = actions.toggle_ignore,
            ["ctrl-h"] = actions.toggle_hidden,
            ["enter"]  = actions.file_edit_or_qf,
        }
    }
})

-- Git support
vim.pack.add({
    { src = "https://github.com/tpope/vim-fugitive" },
})

-- No configuration needed for vim-fugitive

vim.pack.add({
    { src = "https://github.com/vieitesss/miniharp.nvim" },
})

-- [](https://github.com/vieitesss/command.nvim)
require('miniharp').setup({ show_on_autoload = true })

-- [command.nvim](https://github.com/vieitesss/command.nvim)
vim.pack.add({
    { src = "https://github.com/vieitesss/command.nvim" }
})

-- require('command').setup()
