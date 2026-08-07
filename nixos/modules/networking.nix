# nixos/modules/fonts.nix
{ ... }:

{
  # Network related settings
  networking = {
    hostName = "starscream";
    networkmanager = {
      enable = true;
    };

    # Add static hosts to /etc/hosts file
    hosts = {
      "172.19.0.10" = [
        "grafana-kind.mapeus.xyz"
        "prometheus-kind.mapeus.xyz"
        "kiali-kind.mapeus.xyz"
      ];
    };

    firewall = {
      extraCommands = ''
        iptables -A nixos-fw -p tcp -s 172.19.0.0/16 --dport 11434 -j nixos-fw-accept
      '';
    };
  };
}
