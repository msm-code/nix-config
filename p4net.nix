{ pkgs, ... }:
let
in
{
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.wireguard.interfaces = {
    p4net = {
      ips = [ "198.18.70.2/24" ];
      privateKeyFile = "/home/msm/data/wg/p4net.priv";
      listenPort = 51820;

        peers = [{
          publicKey = "ALxno1mlbRdMJ34n0eQXeLb6lukDBrC39X9qZJz3rSU=";

          allowedIPs = [ "198.18.70.0/24" ];

          endpoint = "135.181.113.20:51820";

          persistentKeepalive = 25;
        }
      ];
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
}