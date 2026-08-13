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
        "grafana-kind.alvesm.dev"
        "prometheus-kind.alvesm.dev"
        "kiali-kind.alvesm.dev"
        "kagent-ui-kind.alvesm.dev"
      ];
    };

    firewall = {
      extraCommands = ''
        iptables -A nixos-fw -p tcp -s 172.19.0.0/16 --dport 11434 -j nixos-fw-accept
      '';
    };
  };
}
