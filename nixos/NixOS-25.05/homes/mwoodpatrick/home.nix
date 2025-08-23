{ config, pkgs, ... }:
{
  home-manager = {
    # It's good practice to set this to a recent version
    # stateVersion = "25.05";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.


    # Define a specific user for Home Manager to manage
    users.mwoodpatrick = { pkgs, ... }: {
      home = {
        username = "mwoodpatrick";
        homeDirectory = "/home/mwoodpatrick";
        stateVersion = "25.05";

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
        sessionVariables = {
          EDITOR = "nvim";
          GIT_ROOT = "/mnt/wsl/projects/git";
          KIND_EXPERIMENTAL_PROVIDER = "podman";
          LIBGL_ALWAYS_SOFTWARE = 1; # Need for Flutter since hardware render does not work on my laptops!
          NIX_CFG_DIR = "$GIT_ROOT/nix-wsl";
          PATH = "$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin";
          UV_PYTHON_DOWNLOADS = "never"; # Normal python does not work in NixOS
          # PS1=''\u@\h:\w\ myenv$ ''; # Currently trying out starship
          DIRENV_LOG_FORMAT = ""; # disable direnv output
          # TODO: Check if running on WSL does not appear to work (check for some other env var)
          WSL = if pkgs.hostPlatform.isWindows then "true" else "false";
        };

        packages = with pkgs; [
          bat
          fzf
          tree
          jq
       ];
      };

      imports = [ 
        ./neovim.nix
        # Import nvf’s home-manager module
        # nvf.homeManagerModules.default 
        #  ./nvf.nix
      ];

      programs = {
        # Let Home Manager install and manage itself.
        home-manager.enable = true;
        ripgrep.enable =true;
        fd.enable =true;
  
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
            c = "clear";
            h = "history";
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

        zsh = {
          enable = true;
          oh-my-zsh = {
            enable = true;
            theme = "agnoster";
            plugins = [ "git" "kubectl" "sudo" "history" "fzf" ];
          };
          shellAliases = {
            ll = "ls -lh";
            la = "ls -lha";
            gs = "git status";
            v = "nvim";
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

            init.defaultBranch = "main";
  
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
  };
}
