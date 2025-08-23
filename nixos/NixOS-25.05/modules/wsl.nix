# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

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

  # In the context of the `nix-community/NixOS-WSL` project, `wsl.enable` is a boolean option that specifies whether to **activate the NixOS-WSL module and all its related services and configurations**.
  #
  # When you set `wsl.enable = true;` in your `configuration.nix` file, you are essentially telling the NixOS build system:
  # * "I am running this system inside WSL2."
  # * "Please include all the necessary modules, scripts, and service configurations that make NixOS function correctly within the WSL2 environment."
  #
  # This single line is a powerful declarative statement. It enables a cascade of background configurations, such as native `systemd` support, Windows file system interoperability, and the proper setup of the user environment, that would otherwise be complex to configure manually. It’s a core part of the `NixOS-WSL` project's goal to make the setup as seamless and reproducible as possible.
  #
  # This video provides an excellent guide on how to install and configure NixOS on WSL2 using the `nixos-wsl` project. [Installing NixOS on WSL2 with Flakes](https://www.youtube.com/watch?v=ZuVQds2hncs).
  # https://www.youtube.com/watch?v=ZuVQds2hncs

  wsl = {
    enable = true;

  #   The `wsl.defaultUser` option in a NixOS configuration file is used to set the **default user** that the WSL2 distro will log in as on startup.
  #
  # ### What it Does
  #
  # When you import a NixOS distro using `wsl --import`, it defaults to the `root` user. This means every time you open the distro, you'll be logged in as `root`. The `wsl.defaultUser` option changes this behavior.
  #
  # By setting `wsl.defaultUser = "mwoodpatrick";`, you're telling the NixOS-WSL module to create a regular user named "mwoodpatrick" and to set that user as the default login.
  #
  # ### Why It's Important
  #
  # * **Security:** Running as the `root` user for day-to-day tasks is a security risk. It's best practice to work as a non-privileged user and use `sudo` for administrative tasks.
  # * **Ease of Use:** It eliminates the need for you to manually switch from `root` to your regular user every time you start the distro.
  # * **Consistency:** This declarative approach ensures that the default user is set correctly every time you rebuild the system, which is crucial for a reproducible setup.
  #
  # The `wsl.defaultUser` option is part of the `NixOS-WSL` project and should be used in conjunction with a `users.users` block in your `configuration.nix` that defines the user account itself.
  #
  # ---
  # This video provides a detailed guide on setting the default user in a WSL distro. [WSL uses root user after import | How to set default user in WSL](https://www.youtube.com/watch?v=0qxaFxZd2mQ).
  # http://googleusercontent.com/youtube_content/10

    defaultUser = "mwoodpatrick";
  };
}

