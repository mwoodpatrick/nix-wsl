
# Edit this configuration file to define what should be installed on
# your system. 
#
# [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
# [NixOS Manual](https://nixos.org/manual/nixos/unstable/)
# [NixOS on the Windows Subsystem for Linux](https://nix-community.github.io/NixOS-WSL/index.html)
# [NixOS WSL Options](https://nix-community.github.io/NixOS-WSL/options.html)
#
# Search for option definitions using:
# 
# [Search more than 20 000 options](https://search.nixos.org/options?)
# [WSL Configuration Options](https://nixos.org/manual/nixos/unstable/options.html)
#
# Configuration help:
#
# [Configuration Options](https://nixos.org/manual/nixos/unstable/options.html#ch-options)
# [The Nix configuration file](https://nixos.substack.com/p/the-nix-configuration-file)
#
# Search fot packages using:
#
# [Packages](https://search.nixos.org/packages?channel=unstable)
#
# More detailed info is here:
#
# [Build Your World](https://mynixos.com/)
# [nixos-wsl-starter](https://github.com/LGUG2Z/nixos-wsl-starter#nixos-wsl-starter)
# [Setting Up NixOS on Windows Subsystem for Linux (WSL2)](https://www.greghilston.com/post/nixos-on-wsl/)
# [Intro to Nixos for WSL](https://blog.jimurrito.com/nixos/2024/08/13/intro-to-nixos-for-wsl.html)
# [NixOS on WSL](https://forrestjacobs.com/nixos-on-wsl/)
# [Nix Flakes on WSL](https://xeiaso.net/blog/nix-flakes-4-wsl-2022-05-01/)
# [nixos-wsl](https://github.com/mifix/nixos-wsl)
# [WSL, Neovim, Lua, and the Windows Clipboard](https://mitchellt.com/2022/05/15/WSL-Neovim-Lua-and-the-Windows-Clipboard.html)
# [dotfiles](https://github.com/mitchpaulus/dotfiles)
# [how to create a multiuser nixos flake based system](https://gemini.google.com/app/bb29eccbb15d6cd6)
#
# update channels using: sudo nix-channel --update
# rebuild using: sudo nixos-rebuild switch
{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  # (NixOS-WSL configuration options)[https://nix-community.github.io/NixOS-WSL/options.html)
  # (Advanced settings configuration in WSL)[https://learn.microsoft.com/en-us/windows/wsl/wsl-config#wslconfig]
  wsl = {
    enable = true;  # Whether to enable support for running NixOS as a WSL distribution.
    defaultUser = "mwoodpatrick"; # The name of the default user

    # This section controls interop features from within NixOS
    interop = {
      includePath = true; # Controls adding Windows PATH to NixOS $PATH
      register = true; # Explicitly register the (binfmt_misc handler)[https://en.wikipedia.org/wiki/Binfmt_misc] for Windows executables
    };
  };

  # services.avahi = {
  #   enable = true;
    # Configuration options (optional, see below)
  # };

  # services.automatic-timezoned.enable = true;
  # time.timeZone = "America/Los_Angele";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  environment.systemPackages = with pkgs; [
    # Flakes clones its dependencies through the git command,
    # so git must be installed first
    git
    gh
    neovim
    ripgrep
    wget
  ];
  # Set the default editor to vim
  environment.variables.EDITOR = "nvim";
}
