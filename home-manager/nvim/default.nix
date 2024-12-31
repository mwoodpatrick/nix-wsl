{ inputs, outputs, lib, config, pkgs, ... }: let
#   nixvim = import (builtins.fetchGit {
#     url = "https://github.com/nix-community/nixvim";
#     ref = "main";
#   });

in {
  # You can import other home-manager modules here
  imports = [
    # nixvim.homeManagerModules.nixvim
  ];

#    config.nixvim = {
#       # enable = true;
# 
#       # colorschemes.catppuccin.enable = true;
#       # plugins.lualine.enable = true;
#     };

    # [Neovim and Nix home-manager: Supercharge Your Development Environment](https://www.youtube.com/watch?v=YZAnJ0rwREA)
    # [nvim-nix-video](https://github.com/vimjoyer/nvim-nix-video)
    # {Nixvim: Neovim Distro Powered By Nix](https://www.youtube.com/watch?v=b641h63lqy0)
    # [nixvim-video](https://github.com/vimjoyer/nixvim-video)

  programs = {
    neovim = let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in {
      enable = true; # alternately use nixvim
      defaultEditor = true; # configures neovim to be the default editor using the EDITOR environment variable

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraPackages = with pkgs; [
        lua-language-server
        # A syntax-checking language server using [rnix](https://github.com/nix-community/rnix-parser)
        #       # a parser for the [Nix language](https://nixos.org/)
        # [rnix-lsp](https://github.com/nix-community/rnix-lsp)
        # rnix-lsp

        xclip
        wl-clipboard
      ];

      plugins = with pkgs.vimPlugins; [
        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./plugin/lsp.lua;
        }

        {
          plugin = comment-nvim;
          config = toLua "require(\"Comment\").setup()";
        }

        {
          plugin = gruvbox-nvim;
          config = "colorscheme gruvbox";
        }

        neodev-nvim

        nvim-cmp
        {
          plugin = nvim-cmp;
          config = toLuaFile ./plugin/cmp.lua;
        }

        {
          plugin = telescope-nvim;
          config = toLuaFile ./plugin/telescope.lua;
        }

        telescope-fzf-native-nvim

        cmp_luasnip
        cmp-nvim-lsp

        luasnip
        friendly-snippets

        lualine-nvim
        nvim-web-devicons

        {
          plugin = nvim-treesitter.withPlugins (p: [
            p.tree-sitter-nix
            p.tree-sitter-vim
            p.tree-sitter-bash
            p.tree-sitter-lua
            p.tree-sitter-python
            p.tree-sitter-json
          ]);
          config = toLuaFile ./plugin/treesitter.lua;
        }

        vim-nix

        # {
        #   plugin = vimPlugins.own-onedark-nvim;
        #   config = "colorscheme onedark";
        # }
      ];

      # The Home Manager module does not expose many configuration options.
      # Therefore, the easiest way to get started is to use the extraConfig option.
      # You can copy your old config or directly load your default Neovim config via:

      extraLuaConfig = ''
        ${builtins.readFile ./options.lua}
      '';

      # extraLuaConfig = ''
      #   ${builtins.readFile ./options.lua}
      #   ${builtins.readFile ./plugin/lsp.lua}
      #   ${builtins.readFile ./plugin/cmp.lua}
      #   ${builtins.readFile ./plugin/telescope.lua}
      #   ${builtins.readFile ./plugin/treesitter.lua}
      #   ${builtins.readFile ./plugin/other.lua}
      # '';
    };
  };

}
