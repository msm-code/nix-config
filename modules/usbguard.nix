{ config, pkgs, secrets, ... }: {
  services.usbguard = {
    enable = true;
    rules = builtins.readFile ./data/usbguard_rules.txt;
  };
}
