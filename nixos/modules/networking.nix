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
        "thanos-queryfrontend-kind.alvesm.dev"
        "kibana-kind.alvesm.dev"
      ];
    };
  };
}
