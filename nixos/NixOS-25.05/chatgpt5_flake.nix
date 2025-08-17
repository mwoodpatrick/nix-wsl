{
  description = "NixOS flake for chatgpt_vnc_example with xfce, xrdp, libvirt, tigervnc and access to nixos-unstable";
  inputs = {
    # stable-ish nixpkgs (change pin as you like)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; # change to preferred pin
    # unstable channel to allow selecting unstable packages
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # home-manager (optional; we use native user config, but left here if you want HM integration)
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations.chatgpt_vnc_example = pkgs.lib.nixosSystem {
        inherit system;
        modules = [
          (
            { config, pkgs, ... }:
            {
              imports = [ home-manager.inputs.home-manager.nixosModule ]; # optional
              # Basic identity
              networking.hostName = "chatgpt_vnc_example";
              # Allow unfree packages and enable access to unstable (we pull packages from `unstable` below)
              nixpkgs.config.allowUnfree = true;
              # Basic users
              users.users.mwoodpatrick = {
                isNormalUser = true;
                description = "Default user";
                extraGroups = [
                  "wheel"
                  "libvirt"
                  "networkmanager"
                ];
                home = "/home/mwoodpatrick";
                createHome = true;
                # put your ssh key here if you want:
                # openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA..." ];
              };
              # Enable sudo for wheel
              security.sudo.enable = true;
              security.sudo.wheelNeedsPassword = false;
              # X / XFCE / display manager
              services.xserver.enable = true;
              services.xserver.layout = "us";
              services.xserver.xkbOptions = "caps:escape";
              services.xserver.displayManager.lightdm.enable = true;
              services.xserver.desktopManager.xfce.enable = true;
              # XRDP
              services.xrdp.enable = true;
              # make sure firewall allows RDP
              networking.firewall.allowedTCPPorts = with pkgs.lib; [ 3389 ];
              # Libvirt + qemu_full + virt-manager
              virtualisation.libvirtd.enable = true;
              # prefer the full qemu:
              virtualisation.libvirtd.qemuPackage = unstable.qemu_full;
              virtualisation.libvirtd.extraOptions = ''
                # allow non-root networking if you need to configure bridging/dnsmasq:
              '';
              services.libvirtd.enable = true;
              # dnsmasq (useful for libvirt networking)
              services.dnsmasq.enable = true;
              # Bridge utils for bridging virtual networks
              networking.interfaces.bridge0 = {
                # example; disabled by default. Configure as you need.
                # enable = true;
              };
              # Provide a simple systemd service to run tigervnc for the user on :1
              systemd.services."tigervnc-mwood-:1" = {
                description = "TigerVNC server for mwoodpatrick :1";
                wants = [ "network.target" ];
                after = [ "network.target" ];
                serviceConfig = {
                  Type = "simple";
                  User = "mwoodpatrick";
                  Environment = "HOME=/home/mwoodpatrick";
                  ExecStart = "${pkgs.tigervnc}/bin/vncserver :1 -geometry 1280x800 -localhost=no";
                  ExecStop = "${pkgs.tigervnc}/bin/vncserver -kill :1";
                  Restart = "on-failure";
                };
                wantedBy = [ "multi-user.target" ];
              };
              # Example: create a simple VNC xstartup in the user's home (xfce)
              environment.etc."skel/.vnc/xstartup".text = ''
                #!/bin/sh
                exec /etc/profiles/per-user/mwoodpatrick/bin/startxfce4 &
              '';
              # System packages (combine stable and unstable packages as needed)
              environment.systemPackages = with pkgs; [
                git
                gh # GitHub CLI
                home-manager # included for convenience
                neovim
                wget
                kmod
                libvirt
                virt-manager
                virt-viewer
                libosinfo
                bridge-utils
                dnsmasq
                xrdp
                thunar
                xterm
                xfce.xfce4 # some distributions export a set; fallback below
                gimp
                # pick qemu from unstable (qemu_full)
                unstable.qemu_full
                unstable.qemu-utils # if available in your unstable pin
                unstable.nodejs-24_x # nodejs 24 from unstable; adjust name if it differs
                unstable.nix-ld # nix-ld from unstable if packaged
                unstable.tigervnc # prefer unstable build if you want latest
                # the following might not exist in your nixpkgs pin; see notes:
                # unstable.ollama
              ];
              # Make the system allow access to the `nixos-unstable` input for pkg selection:
              # (we already referenced `unstable` above)
              # Security / Networking mode comment:
              # You mentioned "networking mode Mirrored" — if you meant the Nix cache/substituter
              # mirroring or some specific option, explain and I can add the exact options.
              # If you meant a particular NixOS option, add detail and I will adapt.

              # Enable services you asked for (xrdp done above)
              # If a service module exists for ollama in your nixpkgs, enable it here; fallback to package:
              # services.ollama.enable = true; # <-- only if available in nixpkgs
              # otherwise add to system packages (see above).
              # Allow mounting & virtualization helpers
              boot.kernelModules = [
                "kvm"
                "kvm_intel"
                "kvm_amd"
              ];
              boot.initrd.kernelModules = [ "kvm" ];
              hardware.enableAllFirmware = true;
              # Timezone / locale (set as you prefer)
              time.timeZone = "UTC";
              i18n.defaultLocale = "en_US.UTF-8";
              # Enable basic networking
              networking.networkmanager.enable = true;
              # Enable DBus (required for many desktop things)
              services.dbus.enable = true;
              # Enable polkit for virt-manager
              services.polkit.enable = true;
              # Optional: enable home-manager integration (if you want to manage user dotfiles)
              # programs.home-manager.enable = true;  # already imported above
              home-manager.users.mwoodpatrick = {
                programs = {
                  vim = {
                    enable = false;
                  };
                };
              };
              # Systemd tmpfiles ownership for vnc sockets, etc
              systemd.tmpfiles.rules = [ "d /run/user/1000 0700 mwoodpatrick mwoodpatrick -" ];
              # Minimal firewall: allow ssh/rdp if you want
              networking.firewall.allowedTCPPorts =
                lib.mkForce (config.networking.firewall.allowedTCPPorts or [ ])
                ++ [
                  22
                  3389
                ];
            }
          )
        ];
        # Optional metadata
        configuration = { }; # left empty, configuration is provided in module above
      };
    };
}
