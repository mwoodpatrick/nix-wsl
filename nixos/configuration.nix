# Edit this configuration file to define what should be installed on
# your system. 
#
# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# search fot option definitions using:
# https://search.nixos.org/options?channel=24.05
## 
# see: 
#   [The Nix configuration file](https://nixos.substack.com/p/the-nix-configuration-file)
#   [Options](https://mynixos.com/nixpkgs/options)
#
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
# https://nix-community.github.io/NixOS-WSL/
# https://nix-community.github.io/NixOS-WSL/install.html
# https://nix-community.github.io/NixOS-WSL/options.html
# https://nix-community.github.io/NixOS-WSL/how-to/nix-flakes.html
# https://nix-community.github.io/NixOS-WSL/how-to/vscode.html
# https://wiki.nixos.org/wiki/WSL

# list your channels using: sudo nix-channel --list 
# update channels using: sudo nix-channel --update
# rebuild using: sudo nixos-rebuild switch

{ config, lib, pkgs, nixos-wsl, ... }:

{
  imports = [
    # <nix-ld/modules/nix-ld.nix>
    # include NixOS-WSL modules
    # nixos-wsl/modules
  ];

  # Configure networking

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPortRanges = [
      { from = 4000; to = 4007; }
      { from = 8000; to = 8010; }
    ];
  };

  time.timeZone = "US/Pacific";

  # Handle none NixOS binaries
  # [Dec 2022 Nix-ld: A clean solution for issues with pre-compiled executables on NixOS](https://blog.thalheim.io/2022/12/31/nix-ld-a-clean-solution-for-issues-with-pre-compiled-executables-on-nixos/)
  # [nix-community/nix-ld](https://github.com/nix-community/nix-ld?tab=readme-ov-file#nix-ld)
  # The module in this repository defines a new module under (programs.nix-ld.dev) instead of (programs.nix-ld)
  # to not collide with the nixpkgs version.
  # programs.nix-ld.dev.enable = true;

  users.users.mwoodpatrick = {
        isNormalUser  = true;
        home  = "/home/mwoodpatrick";
        description  = "Mark L. Wood-Patrick";
        extraGroups  = [ "nopasswdlogin" "wheel" "networkmanager"  "libvirtd" ];
        # openssh.authorizedKeys.keys  = [ "ssh-dss AAAAB3Nza... alice@foobar" ];

        # The state version is required and should stay at the version you
        # originally installed.
        # home.stateVersion = "24.05";
  };

  wsl = {
    enable = true;
    defaultUser = "mwoodpatrick";
    startMenuLaunchers = true;
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
  services.nginx = {
    enable = true;
    statusPage = true;
    # logError = "/srv/http/test.local.westie.org/error.log debug"; 
    defaultHTTPListenPort=80; # 8080;
    defaultSSLListenPort=443; # 8443;

    # [Mozilla SSL SSL Configuration Generator](https://ssl-config.mozilla.org/#server=nginx&config=intermediate)
    recommendedTlsSettings = true;

    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = { # aka server blocks
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
  
  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = false;
        allowed-users = [
                        "@wheel"
                        "@builders"
                        "moodpatrick"
                    ];
        substituters = [ "https://nixos-homepage.cachix.org" ];
        trusted-public-keys = [ "nixos-homepage.cachix.org-1:NHKBt7NjLcWfgkX4OR72q7LVldKJe/JOsfIWFDAn/tE=" ];
    };

  environment.systemPackages = with pkgs; [
    # nix # default is 2.18.5
    nixVersions.nix_2_25
    # simple Wayland Configuration
    emptty
    weston
    wayland-utils
    swaybg
    hello-wayland
    wlvncc
    wlcs
    # it provides the command `nom` works just like `nix`
    wbg
    cairo
    # with more details log output
    nix-direnv
    # nixVersions.nix_2_25
    nix-prefetch-github # get hash and other info from GitHub package
    nix-output-monitor
    niv
    spice-vdagent # [Spice](https://www.spice-space.org/)
    # Flakes clones its dependencies through the git command,
    # so git must be installed first
    git
    neovim
    wget
    curl
    direnv
    home-manager
    # kmod is a set of tools to handle common tasks with Linux kernel modules like insert, remove, 
    # list, check properties, resolve dependencies and aliases. These tools are designed on 
    # top of libkmod, a library that is shipped with kmod.
    # [kmod](https://search.nixos.org/packages?channel=unstable&show=kmod&from=0&size=50&sort=relevance&type=packages&query=kmod)
    kmod

    # Extra tools for accessing and modifying virtual machine disk images
    # [libguestfs](https://libguestfs.org/)
    guestfs-tools

    # [Quickemu Project](https://github.com/quickemu-project)
    # [A quick look at Quickemu](https://www.lorenzobettini.it/2024/03/a-quick-look-at-quickemu/)
    quickemu

    # [quickgui](https://github.com/quickemu-project/quickgui)
    # quickgui
  ];

  # Set the default editor to vim
  environment.variables = {
    EDITOR = "nvim";
    GIT_ROOT= "/mnt/wsl/projects/git";
    HOME="/home/mwoodpatrick";
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
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };
  programs.virt-manager.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
