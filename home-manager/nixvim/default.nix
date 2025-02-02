# [The Best of My Neovim Config 2024](https://levelup.gitconnected.com/the-best-of-my-neovim-config-2024-68ab2357efe7)
# [Configuration examples](https://nix-community.github.io/nixvim/user-guide/config-examples.html)
# [Nixvim: Neovim Distro Powered By Nix](https://www.youtube.com/watch?v=b641h63lqy0)
# [All code blocks from the video](https://github.com/vimjoyer/nixvim-video)
# [nixvim docs](https://nix-community.github.io/nixvim/)
# [NixVim - A Neovim configuration system for nix](https://nix-community.github.io/nixvim/)
# [nixvim - github](https://github.com/nix-community/nixvim)
# [nixvim](https://nix-community.github.io/nixvim/user-guide/install.html)
# [nixvim matrix](https://app.element.io/#/room/#nixvim:matrix.org)
# [nixvim documentation](https://app.element.io/#/room/#nixvim-documentation:matrix.org)
# [neovim - Matrix](https://app.element.io/#/room/#neovim-nightly-overlay:nixos.org)
# [my nixvim flake](https://github.com/mwoodpatrick/nix-examples/tree/main/flakes/apps/nixvim)
# [nixvim example configurations](https://github.com/nix-community/nixvim/blob/main/docs/user-guide/config-examples.md)
# [Nixvim: A Neovim configuration system for nix](https://www.reddit.com/r/NixOS/comments/11rd9a8/nixvim_a_neovim_configuration_system_for_nix/)
# [Modular Neovim with Nix](https://juuso.dev/blogPosts/modular-neovim/modular-neovim-with-nix.html)
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
  # Get nixvim helpers (utility functions)
  # [Helpers - nixvim](https://nix-community.github.io/nixvim/user-guide/helpers.html)
  helpers = config.lib.nixvim;
in {
  # You can import other home-manager modules here
  imports = [
    # Import all your configuration modules here
    nixvim.homeManagerModules.nixvim
    ./autocommands.nix
    ./completion.nix
    ./keymappings.nix
    ./options.nix
    ./plugins
    ./todo.nix
  ];
  programs.nixvim = {
    enable = true; # alternately use nixvim
    colorschemes.catppuccin.enable = true;
    defaultEditor = true; # configures neovim to be the default editor using the EDITOR environment variable
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    luaLoader.enable = true;

    extraLuaPackages = ps: [ps.magick];
    extraPackages = [pkgs.imagemagick];
    extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
      name = "vim-just";
      # [fetchFromGitHub](https://ryantm.github.io/nixpkgs/builders/fetchers/#fetchfromgithub)
      # [vim-just](https://github.com/NoahTheDuke/vim-just)
      src = pkgs.fetchFromGitHub {
        owner = "NoahTheDuke";
        repo = "vim-just";
        rev = "e0978aa";
        # [CAUTION! - Derivation variables ignored, installing from tarballs.nixos.org instead?](https://discourse.nixos.org/t/derivation-variables-ignored-installing-from-tarballs-nixos-org-instead/2349)
        # sha256 = lib.fakeSha256;
        # sha256 = "sha256-HiconMn6ZuXz1caYfwFZjn8kgIRlhpSH2kuNLKaMqdE=";
        hash = "sha256-HiconMn6ZuXz1caYfwFZjn8kgIRlhpSH2kuNLKaMqdE=";
      };
    })];
  };
}
