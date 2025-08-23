{ config, pkgs, ... }:
{
  programs.nvf = {
    enable = true;
    settings = {
      colorscheme = "gruvbox";
       lsp = {
        enable = true;
        servers = [ "pyright" "tsserver" "rust_analyzer" ];
      };
      treesitter.enable = true;
      telescope.enable = true;
      # Add extra plugins/modules
      extraPlugins = [
        "nvim-comment"
        "gitsigns.nvim"
      ];
    };
  };
}

