
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
# [Understanding NixOS Modules and Declaring Options](https://britter.dev/blog/2025/01/09/nixos-modules/)
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
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    # <nixos-wsl/modules>
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

    wslConf.network = {
      hostname = "nix-wsl-vm-enabled"; # The hostname of the WSL instance
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

  environment = {
    systemPackages = with pkgs; [
      # Flakes clones its dependencies through the git command,
      # so git must be installed first
      git
      gh
      home-manager
      kind
      kubectl
      neovim
      wget

      # Tools for loading and managing Linux kernel modules
      kmod

      # Add QEMU and other virtualization packages
      qemu_full # or qemu
      qemu-utils
      libvirt # for libvirt CLI tools (virsh)
      virt-manager # For the graphical VM manager
      virt-viewer # Viewer for remote virtual machines
      bridge-utils
      dnsmasq

      # AI
      inputs.cursor.packages.${pkgs.system}.default
      # inputs.claude-desktop.packages.${system}.claude-desktop
      # (pkgs.callPackage ./claude-code.nix {})
      nix-ld # Run unpatched dynamic binaries on NixOS
    ];
 
    # Set the default editor to neovim
    variables = {
      EDITOR = "nvim";
      GIT_ROOT= "/mnt/wsl/projects/git";
      NIXOS_CONFIG_ROOT="/mnt/wsl/projects/git/nix-wsl/nixos/vm-enabled";
    };
  };

  # Allow unprivileged users to run Podman (rootless mode setup)
  # This sets up user namespaces and subuids/subgids for rootless containers
  users.users.mwoodpatrick = {
    isNormalUser = true;
    extraGroups = [ 
      "podman"     # for podman
      "wheel"      # For sudo access
      "kvm"        # Crucial for direct access to /dev/kvm
      "libvirtd"   # To manage VMs via libvirt (virsh, and virt-manager)
      "qemu-libvirtd" # Some setups may benefit from this for QEMU user permissions
    ];
  };

  virtualisation = {
    # Enable Podman service a daemonless container engine for developing, managing, 
    # and running OCI Containers on your Linux System.
    podman.enable = true;

    # Create an alias mapping docker to podman
    podman.dockerCompat = true; # Enable Docker compatibility (optional, but good for tools expecting Docker socket)

    # Enable the libvirt daemon for managing VMs
    libvirtd.enable = true;
  };

  # You might want to enable systemd in WSL2 for more robust service management,
  # though Podman can often run without it.
  # boot.enableSystemd = true;

  # Optional: Enable graphical manager for VMs
  programs.virt-manager.enable = true;

  # Optional: Dconf support for GNOME-based tools like Virt-manager
  programs.dconf.enable = true;

  # Optional: Allow clipboard and display sharing with Spice
  services.spice-vdagentd.enable = true;

  # Optional: Useful if you plan to run NixOS inside a VM
  services.qemuGuest.enable = true;

  # Networking bridge for VMs (can also be configured via virsh)
  networking.firewall.allowedTCPPorts = [ 5900 5901 ]; # Common VNC/SPICE ports
  networking.firewall.allowedUDPPorts = [ 67 68 ];     # DHCP
}
