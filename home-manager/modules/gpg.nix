# Mostly shamelessly stolen from https://github.com/BonusPlay/sysconf/blob/master/home/gpg.nix
{ config, pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    scdaemonSettings.disable-ccid = true;

    # hardening
    # https://www.designed-cybersecurity.com/tutorials/harden-gnupg-config/
    settings = {
      no-comments = true;
      no-emit-version = true;
      keyid-format = "long";
      with-fingerprint = true;
      default-recipient-self = true;
      require-cross-certification = true;
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256 SHA224";
      personal-compress-preferences = "BZIP2 ZLIB ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      default-preference-list = "AES256 AES192 AES SHA512 SHA384 SHA256 SHA224 BZIP2 ZLIB ZIP Uncompressed";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableFishIntegration = true;
    enableSshSupport = true;
    enableZshIntegration = false;
    pinentryFlavor = "curses";

    # hardening
    # https://www.designed-cybersecurity.com/tutorials/harden-gnupg-config/
    defaultCacheTtl = 300;
    defaultCacheTtlSsh = 300;
    maxCacheTtl = 900;
    maxCacheTtlSsh = 900;
  };
}
