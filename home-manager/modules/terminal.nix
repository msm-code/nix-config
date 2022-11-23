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
    interactiveShellInit = ''
      set EDITOR nvim
      ${pkgs.any-nix-shell} fish --info-right | source
    '';
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    extraConfig = builtins.readFile ../dotfiles/tmux.conf;
  };

  home.sessionVariables.EDITOR = "nvim";
}
