# [NixVim - A Neovim configuration system for nix](https://nix-community.github.io/nixvim/)
# [nixvim - github](https://github.com/nix-community/nixvim)
# [nixvim](https://nix-community.github.io/nixvim/user-guide/install.html)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  # see [fetchGit input with ref and narHash specified, is now considered unlocked. #12027](https://github.com/NixOS/nix/issues/12027)
  #   nixvim = import (builtins.fetchGit {
  #     url = "https://github.com/nix-community/nixvim";
  #     ref = "main";
  #   });
  nixvim = inputs.nixvim;
in {
  # You can import other home-manager modules here
  imports = [
    nixvim.homeManagerModules.nixvim
  ];
  programs = {
    nixvim = {
      enable = true; # alternately use nixvim
      colorschemes.catppuccin.enable = true;
      plugins.lualine.enable = true;
      defaultEditor = true; # configures neovim to be the default editor using the EDITOR environment variable
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
  };
}
