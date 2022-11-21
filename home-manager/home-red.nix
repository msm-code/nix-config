{ lib, pkgs, ... }:
{
  targets.genericLinux.enable = true;

  programs.home-manager = {
    enable = true;
  };

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set EDITOR nvim
        any-nix-shell fish --info-right | source
      '';
    };

    tmux = {
      enable = true;
      terminal = "screen-256color";
      extraConfig = builtins.readFile ./dotfiles/tmux.conf;
    };
  };

  home.packages =
    [ (import ./scripts/lastd.nix pkgs) ] ++
    (with pkgs; [
      any-nix-shell
    ]);

  home.sessionVariables.EDITOR = "nvim";
}

