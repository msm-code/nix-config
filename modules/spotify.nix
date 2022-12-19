{ config, pkgs, secrets, ... }:
{
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = "msm2e4d534d";
        password = secrets.spotifypassword;
        device_name = "transient";
      };
    };
  };
}
