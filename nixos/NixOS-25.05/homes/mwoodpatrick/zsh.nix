{ ... }:
{
  programs.zsh = {
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
}
