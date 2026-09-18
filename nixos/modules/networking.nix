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
      "10.10.0.50" = [
        "grafana-talos.alvesm.dev"
        "prometheus-talos.alvesm.dev"
        "kiali-talos.alvesm.dev"
        "kagent-ui-talos.alvesm.dev"
        "thanos-queryfrontend-talos.alvesm.dev"
        "kibana-talos.alvesm.dev"
      ];
    };
  };
}
