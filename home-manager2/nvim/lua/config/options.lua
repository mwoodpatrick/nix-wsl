-- options
--------------------------------------------------------------------------------
-- Relative and absolute line numbers combined
-- [indentation](https://neovim.io/doc/user/indent.html)
vim.o.number = true -- Enable line numbers
vim.o.relativenumber = true -- Enable relative line numbers

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Cursorline
vim.opt.cursorline = true

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Preview substitutions
vim.opt.inccommand = "split"

-- Text wrapping
vim.o.wrap = false -- Disable line wrapping
vim.opt.breakindent = true

-- Tabstops
-- and how many spaces are deleted when you press the <BS> (backspace) key.
-- Pressing <Tab> will insert softtabstop spaces.
-- Commands that indent (like >>) will insert shiftwidth spaces.
vim.o.expandtab = true -- Neovim will never insert a hard tab (\t).
vim.o.tabstop = 2 -- A hard tab character (\t) is rendered as 2 spaces. It is purely a display setting
vim.o.shiftwidth = 2 -- Used by the auto-indent feature when you press <CR> (Enter) enters 2 spaces
vim.o.softtabstop = 2 -- Defines how many spaces are inserted when you press the <Tab> key in Insert mode

-- Window splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Save undo history
vim.opt.undofile = true

-- Set the default border for all floating windows
vim.opt.winborder = "rounded"

vim.o.smartindent = true -- general-purpose indentation behavior that works well for many
-- C-like languages without needing complex, language-specific rules.
-- • Copy the Previous Line's Indentation: Like autoindent, it automatically carries over the indentation from the previous line when you press <CR> (Enter).
-- • Indenting After a Brace {: It intelligently adds an extra level of indentation after you type an opening curly brace {. This is useful for languages like C, C++, Java, JavaScript, etc.
-- • Un-indenting After a Brace }: When you type a closing curly brace } on a new line, it automatically reduces the indentation to match the level of the corresponding opening {.
-- • Indenting After Control Structures: It often provides an extra indentation after keywords like for, if, while, or else, particularly in C-style languages.
-- • Continuing Comments: It keeps the same indentation for subsequent lines within a multi-line comment.
vim.o.cursorline = true -- Highlight the current line
vim.o.termguicolors = true -- Enable 24-bit RGB colors
