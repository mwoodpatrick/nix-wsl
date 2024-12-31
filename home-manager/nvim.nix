{ inputs, outputs, lib, config, pkgs, ... }: let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "main";
  });

in {
  # You can import other home-manager modules here
  imports = [
    nixvim.homeManagerModules.nixvim
  ];

   config.nixvim = {
      # enable = true;

      # colorschemes.catppuccin.enable = true;
      # plugins.lualine.enable = true;
    };
}
