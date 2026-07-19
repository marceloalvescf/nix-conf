{
  pkgs,
  config,
  lib,
  ...
}:

let
  # Create a derivation containing Traefik config files.
  # This ensures the store path is properly tracked and won't be garbage collected.
  traefikConfigDir = pkgs.runCommand "traefik-config" { } ''
    mkdir -p $out
    cp ${./traefik/config/traefik.yaml} $out/traefik.yaml
    cp ${./traefik/config/dynamic.yaml} $out/dynamic.yaml
  '';

  # Create a derivation containing Grafana provisioning config files.
  # This ensures the store path is properly tracked and won't be garbage collected.
  grafanaProvisioningDir = pkgs.runCommand "grafana-provisioning" { } ''
    mkdir -p $out/datasources
    cp ${./grafana/provisioning/datasources/prometheus.yaml} $out/datasources/prometheus.yaml
  '';
in

{
  virtualisation.arion = {
    backend = "docker";
    projects = {
      portainer.settings = {
        imports = [ ./portainer/portainer.nix ];
      };

      autokube.settings = {
        imports = [ ./autokube/autokube.nix ];
      };

      streaming.settings = {
        imports = [ ./streaming/streaming.nix ];
      };

      traefik.settings = {
        imports = [ ./traefik/traefik.nix ];
        _module.args.traefikEnvFile = config.sops.templates."traefik-cloudflare.env".path;
        _module.args.traefikConfigDir = traefikConfigDir;
      };

      grafana.settings = {
        imports = [ ./grafana/grafana.nix ];
        _module.args.grafanaPasswordEnvFile = config.sops.templates."grafana-admin-password.env".path;
        _module.args.grafanaProvisioningDir = grafanaProvisioningDir;
      };
    };
  };

  systemd.services.arion-streaming.wantedBy = lib.mkForce [ ];

  environment.systemPackages = with pkgs; [
    arion
  ];
}
