{ config, pkgs, ... }:
{
  # Define a user account.
  users.users.mwoodpatrick = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [ "wheel" ]; # TODO add "networkmanager" "libvirt"
    description = "Default user mwoodpatrick";
  };
  security.sudo.wheelNeedsPassword = false;
}
