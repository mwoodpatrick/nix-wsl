# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on

# [nix.dev[(https://nix.dev)
# [Nix Manual](https://nix.dev/manual/nix)
# [NixOS Search - Packages](https://search.nixos.org/packages)
# [NixOS Search - Options](https://search.nixos.org/options)
#
# [Home Manager Manual](https://nix-community.github.io/home-manager/)
# [Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml)
#
# [NixOS tutorial - Nix Packages](https://www.youtube.com/watch?v=CqFcl4BmbN4&t=958s)
# [Ultimate NixOS Guide](https://www.youtube.com/playlist?list=PLko9chwSoP-15ZtZxu64k_CuTzXrFpxPE)
# [Stable Nix Packages Manual](https://nixos.org/manual/nixpkgs/stable/#preface)
# [Unstable Nix Packages Manual](https://nixos.org/manual/nixpkgs/unstable/#preface)
# [Nix Packages Manual](https://ryantm.github.io/nixpkgs/#preface)


{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default # This is the correct, flake-native way
  ];


  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # Set the hostname for your NixOS instance.
  # Issue: does not seem to do anything
  networking.hostName = "my-nixos-pc";

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Set your system-wide packages.
  # Allow unfree packages, which is necessary for gh.
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    gcc15
    git
    gh
    # [nixfmt](https://github.com/NixOS/nixfmt)
    nixfmt-rfc-style
    # Adds the 'hello' command to your environment. It prints a friendly
    # "Hello, world!" when run.
    hello
  	python314

    # checkers.enable =true;
    statix
    deadnix

  	tree-sitter
    vim-full
  	vimPlugins.nvim-treesitter-parsers.python
    tmux
    wget
  ];

  programs = {
    # (Setup VSCode Remote)[https://nix-community.github.io/NixOS-WSL/how-to/vscode.html]
    # (nix-ld)[https://github.com/nix-community/nix-ld]
    nix-ld.enable = true;
  };
}
