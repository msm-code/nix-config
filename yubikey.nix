# A module to add support my yubikey.
{ config, pkgs, ... }:
{
    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.pcscd.enable = true;
    environment.systemPackages = with pkgs; [
        yubioath-desktop
    ];
}
