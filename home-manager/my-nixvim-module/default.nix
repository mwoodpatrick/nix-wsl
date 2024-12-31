{ config, lib, pkgs, ... }:
with lib; let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "main";
  });

  nixvimcfg = config.nixvim;
  cfg = config.mynixvim;
in {
  imports = [
    # paths of other modules
    nixvim.homeManagerModules.nixvim
  ];

  config.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
  };
  
  options = {
    # option declarations
    mynixvim = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable my custom service.";
      };
      message = mkOption {
        type = types.str;
        default = "Hello, world!";
        description = "A custom message for my service.";
      };
    };
  };

  # config = mkIf cfg.enable {
  # option definitions
  #   };
}
