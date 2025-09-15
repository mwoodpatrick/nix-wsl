-- options

local opt = vim.opt  -- to set options
local is_wsl = vim.env.WSL_DISTRO_NAME ~= nil

if is_wsl then
  -- Use win32yank when running on WSL
  vim.g.clipboard = {
    name = 'win32yank',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
else
  -- Use a standard clipboard manager for other Linux systems
  opt.clipboard = 'unnamedplus'
end

--------------------------------------------------------------------------------
-- Relative and absolute line numbers combined
-- [indentation](https://neovim.io/doc/user/indent.html)
opt.number = true -- Enable line numbers
opt.relativenumber = true -- Enable relative line numbers

-- Keep signcolumn on by default
opt.signcolumn = "yes"

-- Cursorline
opt.cursorline = true

-- Show whitespace characters
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Preview substitutions
opt.inccommand = "split"

-- Text wrapping
opt.wrap = false -- Disable line wrapping
opt.breakindent = true

-- -- 80th column
opt.colorcolumn = "80"

-- Tabstops
-- [indentation](https://neovim.io/doc/user/indent.html)
-- and how many spaces are deleted when you press the <BS> (backspace) key.
-- Pressing <Tab> will insert softtabstop spaces.
-- Commands that indent (like >>) will insert shiftwidth spaces.
opt.expandtab = true -- Neovim will never insert a hard tab (\t).
opt.tabstop = 2 -- A hard tab character (\t) is rendered as 2 spaces. It is purely a display setting
opt.shiftwidth = 2 -- Used by the auto-indent feature when you press <CR> (Enter) enters 2 spaces
opt.softtabstop = 2 -- Defines how many spaces are inserted when you press the <Tab> key in Insert mode

-- Window splitting
opt.splitright = true
opt.splitbelow = true

-- Save undo history
opt.undofile = true

-- Set the default border for all floating windows
opt.winborder = "rounded"

opt.smartindent = true -- general-purpose indentation behavior that works well for many
-- C-like languages without needing complex, language-specific rules.
-- • Copy the Previous Line's Indentation: Like autoindent, it automatically carries over the indentation from the previous line when you press <CR> (Enter).
-- • Indenting After a Brace {: It intelligently adds an extra level of indentation after you type an opening curly brace {. This is useful for languages like C, C++, Java, JavaScript, etc.
-- • Un-indenting After a Brace }: When you type a closing curly brace } on a new line, it automatically reduces the indentation to match the level of the corresponding opening {.
-- • Indenting After Control Structures: It often provides an extra indentation after keywords like for, if, while, or else, particularly in C-style languages.
-- • Continuing Comments: It keeps the same indentation for subsequent lines within a multi-line comment.
opt.cursorline = true -- Highlight the current line
opt.termguicolors = true -- Enable 24-bit RGB colors

opt.backup = false -- creates a backup file
opt.cmdheight = 1 -- more space in the neovim command line for displaying messages
opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.mouse = "a" -- allow the mouse to be used in neovim
opt.pumheight = 10 -- pop up menu height
opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
opt.showtabline = 0 -- always show tabs
opt.swapfile = false -- creates a swapfile
opt.timeoutlen = 500 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.updatetime = 100 -- faster completion (4000ms default)
opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
opt.laststatus = 3 -- only the last window will always have a status line
-- opt.showcmd = false -- hide (partial) command in the last line of the screen (for performance)
-- opt.ruler = false -- hide the line and column number of the cursor position
opt.numberwidth = 4 -- minimal number of columns to use for the line number {default 4}
opt.scrolloff = 3 -- minimal number of screen lines to keep above and below the cursor
opt.sidescrolloff = 3 -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
-- opt.shortmess:append("c") -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"
-- opt.whichwrap:append("<,>,[,],h,l") -- keys allowed to move to the previous/next line when the beginning/end of line is reached
-- 
-- opt.autoindent=true -- Copy indent from current line when starting a new line
-- opt.autowrite=true  -- Write the contents of the file, if it has been modified
opt.incsearch=true -- While typing a search command, show where the pattern, as it was typed so far, matches
opt.wildmenu=true -- On pressing 'wildchar' (usually <Tab>) to invoke completion, the possible matches are shown.
opt.wildmode='longest,list,full' -- Completion mode that is used for the character specified with 'wildchar'.
opt.shell="bash" -- Name of the shell to use for ! and :! commands.
opt.shellslash=true -- When set, a forward slash is used when expanding file names.
opt.makeprg='gmake' -- Program to use for the ":make" command
opt.smarttab=true   -- When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'.  
--                     'tabstop' or 'softtabstop' is used in other places.  A
-- 	                   <BS> will delete a 'shiftwidth' worth of space at the start of the line.
