{ lib, pkgs, ... }:
{
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
}