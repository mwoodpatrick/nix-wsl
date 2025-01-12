# Fully declarative implementation of microvm
# [Declarative MicroVMs](https://astro.github.io/microvm.nix/declarative.html)

{
  user,
  self,
  ...
}: {
  imports = [
    ./networking.nix
  ];
  microvm = {
    autostart = [
      "Example"
    #  "Minecraft"
    ];
    vms = {
      # Minecraft = {
      #   flake = self;
      #   updateFlake = "git+file:///home/${user}/.nixconf";
      # };

      Example = {
        flake = self;
        updateFlake = "git+file:///home/${user}/.nixconf";
      };

      # vmname = {
      #   flake = self;
      #   updateFlake = "git+file://(location to the flake of the microvm)"
      # }
    };
  };
}
