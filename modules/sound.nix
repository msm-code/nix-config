{ config, pkgs, secrets, ... }:
{
  # Enable pulseaudio system-wide
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;

  # Workaround for mpd - we connect with a different user so let's use IP instead.
  hardware.pulseaudio.extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";

  services.mpdscribble = {
    enable = true;
    endpoints = {
      "last.fm" = {
        username = secrets.lastFmUsername;
        passwordFile = "${pkgs.writeText "config" secrets.lastFmPassword}";
      };
    };
  };

  services.mpd = {
    enable = true;
    musicDirectory = "/var/music";
    extraConfig = ''
      # Primary audio output for pulseaudio.
      audio_output {
        type "pulse"
        name "Mpd"  # arbitrary name
        server "127.0.0.1"
      }

      # Secondary audio output - necessary only for ncmcpp visualiser support.
      audio_output {
        type "fifo"
        name "Mpd visualiser feed"
        path "/tmp/mpd.fifo"
        format "44100:16:2"
      }
    '';
  };

  # TODO: put
  # visualizer_data_source = /tmp/mpd.fifo
  # in ~/.config/ncmpcpp/config

  # Custom build of ncmpcpp (with visualiser support).
  environment.systemPackages = with pkgs; [
    (ncmpcpp.override { visualizerSupport = true; })
  ];
}
