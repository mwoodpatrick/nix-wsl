# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# [NixOS Search - Packages](https://search.nixos.org/packages)
# [NixOS Search - Options](https://search.nixos.org/options)

# [NixOS tutorial - Nix Packages](https://www.youtube.com/watch?v=CqFcl4BmbN4&t=958s)

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default # This is the correct, flake-native way
  ];

  # Define a user account.
  users.users.mwoodpatrick = {
    isNormalUser = true;
    home = "/home/mwoodpatrick";
    shell = pkgs.bash;
    extraGroups = [ "wheel" ];
  };

  # Define a specific user for Home Manager to manage
  home-manager.users.mwoodpatrick = {
    # It's good practice to set this to a recent version
    home.stateVersion = "25.05"; 
    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
      # Adds the 'hello' command to your environment. It prints a friendly
      # "Hello, world!" when run.
      hello
      neovim
      tmux
      git
    ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  /etc/profiles/per-user/mwoodpatrick/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  # Note these env vars are written to:
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    EDITOR = "nvim";
    GIT_ROOT = "/mnt/wsl/projects/git";
    KIND_EXPERIMENTAL_PROVIDER = "podman";
    LIBGL_ALWAYS_SOFTWARE = 1; # Need for Flutter since hardware render does not work on my laptops!
    NIX_CFG_DIR="$GIT_ROOT/nix-wsl";
    PATH = "$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin";
    UV_PYTHON_DOWNLOADS = "never"; # Normal python does not work in NixOS
    # PS1=''\u@\h:\w\ myenv$ ''; # Currently trying out starship
    DIRENV_LOG_FORMAT=""; # disable direnv output
    # TODO: Check if running on WSL does not appear to work (check for some other env var)
    WSL = if pkgs.hostPlatform.isWindows then "true" else "false";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    bash = {
      enable = true;
      enableCompletion = true;
      # Add your custom bashrc here
      bashrcExtra = ''
        # added from home.nix
        source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
        #end, added from home.nix
      '';

      # set some aliases, feel free to add more or remove some
      shellAliases = {
        c  = "clear";
        h  = "history";
        hl = "history|less";
        ht = "history|tail -40";
        he = "nvim $NIXOS_CONFIG_ROOT/home/home.nix";
        hs = "home-manager switch --flake $NIXOS_CONFIG_ROOT/home;source ~/.bashrc";
        myps = "ps -w -f -u $USER";
        ncd = "cd $NIXOS_CONFIG_ROOT";
        ne = "nvim $NIXOS_CONFIG_ROOT/flake.nix";
        ns = "sudo nixos-rebuild switch --flake $NIXOS_CONFIG_ROOT#my-nix2505_wsl";
        ngc = "nix-collect-garbage -d";
        j = "jobs";
        k = "kubectl";
        urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
        urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
        wsl = "wsl.exe";
        wterm = "/mnt/c/Program\\ Files/WezTerm/wezterm.exe &";
      };
    };

    # Enable the Git program configuration
    git = {
      enable = true;
      lfs.enable = true;

      # Global user settings
      userEmail = "mwoodpatrick@gmail.com"; # your email
      userName = "Mark L. Wood-Patrick"; # your name

      # Global Git options (equivalent to git config --global)
      extraConfig = {
        # Core settings
        core = {
          editor = "nvim"; # Your preferred Git editor (e.g., "vim", "code --wait", "nano")
          # autoCrlf = "input"; # For consistent line endings, especially on Windows/WSL
          # pager = "delta"; # If you use a custom pager like delta
        };
  
        # Aliases
        alias = {
          co = "checkout";
          br = "branch";
          ci = "commit";
          st = "status";
          lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        };
  
        # Credential helper (important for GitHub/GitLab authentication)
        credential = {
          helper = "store"; # Or "cache", or a more secure helper if needed
          # store = {
          #   helper = "cache --timeout=3600"; # Cache credentials for 1 hour
          # };
        };
  
        # Include other files (useful for organizing per-host or sensitive configs)
        # include = {
        #   path = "~/path/to/my/other-git-config";
        # };
  
        # Protocol helpers (e.g., for GitHub CLI or specific protocols)
        # url."git@github.com:".insteadOf = "https://github.com/";
  
        # Push settings
        push = {
          default = "current"; # Pushes the current branch to the same-named remote branch
        };
  
        # Pull settings
        pull = {
          rebase = true; # Prefer rebase over merge for 'git pull'
        };
  
        # Diff settings (e.g., using diff-so-fancy or delta)
        # diff = {
        #   tool = "default-difftool";
        # };
        # difftool."default-difftool".cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
  
        # Init template directory (for custom Git hooks or templates)
        # init = {
        #   templatedir = "~/.git_template";
        # };
  
        # Signing commits
        # commit = {
        #   gpgsign = true;
        # };
        # gpg.program = "gpg"; # Path to your GPG program
      };
  
      # Or you can use specific options for common configurations:
      # enableLfs = true; # To enable Git LFS support
      # ignores = [ ".DS_Store" "node_modules/" ]; # Global .gitignore entries
    };
  };

  };

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

  wsl.enable = true;

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

  wsl.defaultUser = "mwoodpatrick";

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
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Set your system-wide packages.
  # Allow unfree packages, which is necessary for gh.
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    gh
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;

      # You can add a custom vimscript or Lua configuration here.
      # For vimscript, use the `customRC` option.
      configure = {
        customRC = ''
          set number
          set number relativenumber
          set tabstop=2
          set shiftwidth=2
          set expandtab
        '';
      };
    };
  };
}
