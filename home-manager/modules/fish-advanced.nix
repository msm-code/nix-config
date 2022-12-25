{ lib, pkgs, ... }:
{
  xdg.configFile."starship.toml" = {
    source = pkgs.writeText "config" (builtins.readFile ../dotfiles/starship.toml);
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = { };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    interactiveShellInit = ''
    task
    '';
  };
}
