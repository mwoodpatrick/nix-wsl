{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    
    extraPackages = with pkgs; [ nodejs_24 python3Packages.pip python3Packages.virtualenv ];
    plugins = with pkgs.vimPlugins; [
      # nvim-treesitter
      nvim-treesitter.withAllGrammars
      # nvim-treesitter.withPlugins (p: [ p.c p.python ])
      telescope-nvim
      plenary-nvim
      nvim-lspconfig
      # coc-pyright
      gruvbox
    ];
  
    # colorscheme desert
    extraConfig = ''
      set nobackup
      syntax on
      colorscheme gruvbox
      set nocompatible
      set wildmode=longest,list,full
      set wildmenu
      set shell=bash
      set ssl
      set autoindent
      set autowrite
      set incsearch
      set smartcase 
      set ignorecase
    '';
  
    extraLuaConfig = ''
      vim.o.number = true -- Enable line numbers
      -- vim.o.relativenumber = true -- Enable relative line numbers
      -- [indentation](https://neovim.io/doc/user/indent.html)
      vim.o.tabstop = 2 -- A hard tab character (\t) is rendered as 2 spaces. It is purely a display setting
      vim.o.shiftwidth = 2 -- Used by the auto-indent feature when you press <CR> (Enter) enters 2 spaces
      vim.o.softtabstop = 2 -- Defines how many spaces are inserted when you press the <Tab> key in Insert mode
                            -- and how many spaces are deleted when you press the <BS> (backspace) key.
      vim.o.expandtab = true -- Neovim will never insert a hard tab (\t). 
                             -- Pressing <Tab> will insert softtabstop spaces. 
                             -- Commands that indent (like >>) will insert shiftwidth spaces. 
      vim.o.smartindent = true -- general-purpose indentation behavior that works well for many 
                               -- C-like languages without needing complex, language-specific rules.
                               -- • Copy the Previous Line's Indentation: Like autoindent, it automatically carries over the indentation from the previous line when you press <CR> (Enter).
                                -- • Indenting After a Brace {: It intelligently adds an extra level of indentation after you type an opening curly brace {. This is useful for languages like C, C++, Java, JavaScript, etc.
                                -- • Un-indenting After a Brace }: When you type a closing curly brace } on a new line, it automatically reduces the indentation to match the level of the corresponding opening {.
                                -- • Indenting After Control Structures: It often provides an extra indentation after keywords like for, if, while, or else, particularly in C-style languages.
                                -- • Continuing Comments: It keeps the same indentation for subsequent lines within a multi-line comment.
       vim.o.wrap = false -- Disable line wrapping
       vim.o.cursorline = true -- Highlight the current line
       vim.o.termguicolors = true -- Enable 24-bit RGB colors
  
       -- Setup LSP
       local lspconfig = require('lspconfig')
       lspconfig.pyright.setup {}
       require'nvim-treesitter.configs'.setup { highlight = { enable = true } }
       require('telescope').setup{}
       lspconfig.ts_ls.setup{}
    '';
  };
}

