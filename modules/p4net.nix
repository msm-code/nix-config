{ config, pkgs, ... }:
{
  services.p4net = {
    enable = true;
    privateKeyFile = "/home/msm/data/wg/p4net.priv";
    ips = "198.18.70.2/16";
    instances = {
      home = {
        listenPort = 51820;
        peers = [{
          # msm (p4vps)
          route = "198.18.0.0/16";
          publicKey = "3hnEZtMv/k9PnoSAbEMrccG6bA3Paq1vwOafppGJlRc=";
          allowedIPs = [ "198.18.0.0/16" ];
          endpoint = "145.239.81.240:51820";
        }];
      };
    };
  };
}
