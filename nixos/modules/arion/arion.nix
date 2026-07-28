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

  # Read the unit name back from the project instead of hardcoding
  # "arion-streaming", so it cannot drift from the project definition.
  streamingService = config.virtualisation.arion.projects.streaming.serviceName;
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

  # Arion wants every project on multi-user.target. Detaching the unit keeps
  # `streaming` declared but off at boot; start it on demand with
  # `systemctl start arion-streaming`.
  systemd.services.${streamingService}.wantedBy = lib.mkForce [ ];

  environment.systemPackages = with pkgs; [
    arion
  ];
}
