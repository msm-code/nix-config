{ config, pkgs, ... }:
{
  systemd.user.services.yubikey-touch-detector = {
    enable = true;
    description = "yubikey-touch-detector";
    script = "${pkgs.yubikey-touch-detector} --libnotify";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };
}
