{ lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "msm";
    userEmail = "msm@tailcall.net";
    extraConfig = {
      alias.lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%as)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
      alias.lgg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%H%C(reset) - %C(bold green)(%ai)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
      init.defaultBranch = "master";
    };
  };

  programs.fish = {
    enable = true;
    shellAbbrs = {
      gc = "git checkout";
      gd = "git diff";
      gdc = "git diff --cached";
      gl = "git lg";
      gp = "git push origin (git branch --show-current)";
      gs = "git status";
      k = "kubectl";
      kgp = "kubectl get pod";
      kgs = "kubectl get service";
      ns = "nix-shell -p";
      s = "sudo";
      t = "todoist";
      td = "todoist close";
      tl = "todoist\ --color\ list\ always\ --filter\ \'p1\ \|\ overdue\ \|\ today\ \|\ tomorrow\'";
      ts = "todoist sync";
      x = "xargs -i,,";
      xc = "wl-copy";
    };
    interactiveShellInit = ''
      set EDITOR nvim
      any-nix-shell fish --info-right | source
    '';
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    extraConfig = builtins.readFile ../dotfiles/tmux.conf;
  };

  home.sessionVariables.EDITOR = "nvim";
}
