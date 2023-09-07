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
      commit.gpgsign = "true";
      user.signingkey = "9071B2C50B41E7BB";
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
      nrs = "sudo nixos-rebuild switch --flake ~/Projects/System/";
      s = "sudo";
      t = "task";
      ts = "task sync";
      x = "xargs -i,,";
      xc = "wl-copy";
      of = "fd .otp.gpg ~/.password-store/ -d 8 | cut -d/ -f5- | sed 's/[.]gpg//' | fzf | xargs -i,, pass otp ,, | wl-copy";
      note = "touch ~/Projects/journal/(date +%Y-%m-%d).txt; nvim ~/Projects/journal/(date +%Y-%m-%d).txt";
      pf = "/home/msm/opt/passfzf";
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
