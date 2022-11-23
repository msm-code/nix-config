{ lib, pkgs, ... }:
{
  targets.genericLinux.enable = true;

  programs.home-manager = {
    enable = true;
  };

  imports = [
    ./modules/terminal.nix
    # ./modules/nvim.nix
  ];

  home.packages =
    [ (import ./scripts/lastd.nix pkgs) ] ++
    (with pkgs; [
      any-nix-shell
    ]);

}

