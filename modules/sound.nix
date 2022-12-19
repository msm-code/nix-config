{ config, pkgs, ... }:
{
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;

  # Workaround for mpd - we connect with a different user.
  hardware.pulseaudio.extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";

  services.mpd = {
    enable = true;
    musicDirectory = "/var/music";
    extraConfig = ''
      audio_output {
        type "pulse"
        name "Mpd"  # arbitrary name
        server "127.0.0.1"
      }
    '';
  };

  environment.systemPackages = with pkgs; [
    ncmpcpp
  ];
}
