# A module to add support my yubikey.
{ config, pkgs, ... }:
{
    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.pcscd.enable = true;
    environment.systemPackages = with pkgs; [
        yubioath-desktop
    ];

    # enable the pam module
    security.pam.u2f.enable = true;
    security.pam.services.swaylock = {};
    security.pam.u2f.control = "required";
}
