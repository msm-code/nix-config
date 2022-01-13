{ config, pkgs, secrets, ... }: {
  services.borgbackup.jobs.msm-transient = {
    paths = [
      "/home/msm/data"
      "/home/msm/Projects"
      "/home/msm/Pictures"
      "/home/msm/.config"
      "/home/msm/.ssh"
    ];
    encryption = {
      mode = "repokey";
      passphrase = secrets.borgpassword;
    };
    repo = "msm@pandora.local:/storage/borg-transient";
    compression = "auto,zstd";
    startAt = "daily";
    user = "msm";
    group = "users";
  };
}
