# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
#
# Edit this configuration file to define what should be installed on
# your system.
#
# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# search fot option definitions using:
#
# [Search nix options](https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=etc)
# [NixOS-WSL specific options](https://nix-community.github.io/NixOS-WSL/options.html)
#
# see:
#   [The Nix configuration file](https://nixos.substack.com/p/the-nix-configuration-file)
#   [Options](https://mynixos.com/nixpkgs/options)
#
# [Search for packages to install](https://search.nixos.org/packages)
# [Search for functions](https://noogle.dev/)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  nixos-wsl,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # <nix-ld/modules/nix-ld.nix>
    # include NixOS-WSL modules
    # nixos-wsl/modules

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    # Diaabled for WSL
    # ./hardware-configuration.nix
  ];

  # Configure networking

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443];
    allowedUDPPortRanges = [
      {
        from = 4000;
        to = 4007;
      }
      {
        from = 8000;
        to = 8010;
      }
    ];
  };

  time.timeZone = "US/Pacific";

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable the Flakes feature and the accompanying new nix command-line tool
      # experimental-features = "nix-command flakes";
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;

      allowed-users = [
        "@wheel"
        "@builders"
        "moodpatrick"
      ];

      substituters = ["https://nixos-homepage.cachix.org"];
      trusted-public-keys = ["nixos-homepage.cachix.org-1:NHKBt7NjLcWfgkX4OR72q7LVldKJe/JOsfIWFDAn/tE="];
    };

    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # TODO: Add the rest of your current configuration

  # TODO: Set your hostname
  networking.hostName = "nix-wsl";

  users.users.mwoodpatrick = {
    # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
    # TODO: You can set an initial password for your user.
    # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
    # Be sure to change it (using passwd) after rebooting!
    # initialPassword = "";

    isNormalUser = true;
    home = "/home/mwoodpatrick";
    description = "Mark L. Wood-Patrick";
    extraGroups = ["wheel" "networkmanager" "libvirtd"];
    # openssh.authorizedKeys.keys  = [ "ssh-dss AAAAB3Nza... alice@foobar" ];
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
  };

  # [NixOS-WSL specific options](https://nix-community.github.io/NixOS-WSL/options.html)
  wsl = {
    enable = true;
    defaultUser = "mwoodpatrick";
    startMenuLaunchers = true;
  };

  # my services
  services = {
    # This setups a SSH server. Very important if you're setting up a headless system.
    # Feel free to remove if you don't need it.
    openssh = {
      enable = true;
      settings = {
        # Opinionated: forbid root login through SSH.
        PermitRootLogin = "no";
        # Opinionated: use keys only.
        # Remove if you want to SSH using passwords
        # PasswordAuthentication = false;
      };
    };

    # TODO: review nix nginx configs & how they map into nginx configs
    # Many other DO tutorials need to review
    # [Nginx - NixOS wiki](https://nixos.wiki/wiki/Nginx)
    # [Trying to set up nginx on my home server](https://www.reddit.com/r/NixOS/comments/g31u03/trying_to_set_up_nginx_on_my_home_server/?rdt=49971)
    # [Configuring Logging](https://docs.nginx.com/nginx/admin-guide/monitoring/logging/)
    # [services.nginx](https://search.nixos.org/options?query=services.nginx)
    # [nginx/default.nix](https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/web-servers/nginx/default.nix)
    # [nhinx tests](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests) see nginx*.nix
    # [nginx options](https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/web-servers/nginx/default.nix)
    # [Understanding Nginx Server and Location Block Selection Algorithms](https://www.digitalocean.com/community/tutorials/understanding-nginx-server-and-location-block-selection-algorithms#matching-location-blocks)
    # [How To Set Up Nginx Server Blocks (Virtual Hosts) on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-virtual-hosts-on-ubuntu-16-04)
    # access log: /var/log/nginx/access.log
    # error log: (/var/log/nginx/error.log)
    # log journalctl -xeu nginx.service|less
    # generated config file: /nix/store/<hash>-nginx.conf

    nginx = {
      enable = true;
      statusPage = true;
      # logError = "/srv/http/test.local.westie.org/error.log debug";
      defaultHTTPListenPort = 80; # 8080;
      defaultSSLListenPort = 443; # 8443;

      # [Mozilla SSL SSL Configuration Generator](https://ssl-config.mozilla.org/#server=nginx&config=intermediate)
      recommendedTlsSettings = true;

      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      virtualHosts = {
        # aka server blocks
        localhost = {
          root = "/mnt/wsl/projects/www";

          serverAliases = ["westie.org" "www.westie.org"];

          locations."/ping" = {
            return = "200 '<html><body>It works</body></html>'";
            extraConfig = ''
              default_type text/html;
            '';
          };

          locations."/test" = {
            # error_log = "/srv/http/test.local.westie.org/error.log";
            # access_log = "/srv/http/test.local.westie.org/access.log";
          };
        };

        # "hydra.example.com" = {
        #   forceSSL = true;
        #   enableACME = true;
        #   locations."/" = {
        #       proxyPass = "http://localhost:3000";
        #   };
      };
    };
  };

  # Gloabl OS settings
  environment = {
    # List of packages that should be installed system-wide
    systemPackages = with pkgs; [
      nixVersions.nix_2_25 # package manager
      # provides the command `nom` (nix output monitor) works just like `nix` with more details log output
      nix-output-monitor
      nix-direnv # Fast, persistent use_nix implementation for direnv
      nix-prefetch-github # get hash and other info from GitHub package
      niv # Easy dependency management for Nix projects
      spice-vdagent # Enhanced SPICE integration for linux QEMU guest [Spice](https://www.spice-space.org/)
      # Flakes clones its dependencies through the git command, so git must be installed first
      git # Distributed version control system
      # Handle none NixOS binaries
      # [Dec 2022 Nix-ld: A clean solution for issues with pre-compiled executables on NixOS](https://blog.thalheim.io/2022/12/31/nix-ld-a-clean-solution-for-issues-with-pre-compiled-executables-on-nixos/)
      # [nix-community/nix-ld](https://github.com/nix-community/nix-ld?tab=readme-ov-file#nix-ld)
      # The module in this repository defines a new module under (programs.nix-ld.dev) instead of (programs.nix-ld)
      # to not collide with the nixpkgs version.
      # programs.nix-ld.dev.enable = true;
      nix-ld # Run unpatched dynamic binaries on NixOS
      wget # Tool for retrieving files using HTTP, HTTPS, and FTP
      curl # Command line tool for transferring files with URL syntax
      home-manager # Nix-based user environment configurator
      # kmod # a set of tools to handle common tasks with Linux kernel modules like insert, remove,
      # list, check properties, resolve dependencies and aliases. These tools are designed on
      # top of libkmod, a library that is shipped with kmod.
      # [kmod](https://search.nixos.org/packages?channel=unstable&show=kmod&from=0&size=50&sort=relevance&type=packages&query=kmod)

      # Extra tools for accessing and modifying virtual machine disk images
      # [libguestfs](https://libguestfs.org/)
      guestfs-tools # Extra tools for accessing and modifying virtual machine disk images

      # [Quickemu Project](https://github.com/quickemu-project)
      # [A quick look at Quickemu](https://www.lorenzobettini.it/2024/03/a-quick-look-at-quickemu/)
      quickemu

      # [quickgui](https://github.com/quickemu-project/quickgui)
      # quickgui
    ];

    # environment variables that should be set globally.
    variables = rec {
      EDITOR = "nvim";
      GIT_ROOT = "/mnt/wsl/projects/git";
      NIX_CFG_DIR = "${GIT_ROOT}/nix-wsl";
      NIX_CFG = "${NIX_CFG_DIR}#nix-wsl";
      HOME = "/home/mwoodpatrick";
    };

    # Sets environment variables for user sessions.
    sessionVariables = {
      # TERM = "xterm-256color";
    };

    # List of directories to be symlinked in /run/current-system/sw.
    pathsToLink = ["/usr/share/doc"];
  };

  # Enable virtualization
  # [Virt-manager](https://nixos.wiki/wiki/Virt-manager)
  # [Libvirt](https://nixos.wiki/wiki/Libvirt)
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          })
          .fd
        ];
      };
    };
  };

  programs = {
    nix-ld.enable = true;
    virt-manager.enable = true;
  };

  # [Fonts](https://nixos.wiki/wiki/Fonts)
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
