{ ... }:
{
  # Enable the Git program configuration
  programs.git = {
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
}
