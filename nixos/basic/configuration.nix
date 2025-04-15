{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl = {
  	enable = true;
  	defaultUser = "mwoodpatrick";
	interop.includePath = true;
	};

  services.avahi = {
    enable = true;
    # Configuration options (optional, see below)
  };
  services.automatic-timezoned.enable = true;
  # time.timeZone = "America/Los_Angele";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
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
