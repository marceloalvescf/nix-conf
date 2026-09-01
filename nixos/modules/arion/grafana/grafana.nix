{ grafanaPasswordEnvFile, grafanaProvisioningDir, ... }:

{
  project.name = "grafana";

  services = {
    grafana = {
      service = {
        image = "grafana/grafana:latest";
        container_name = "grafana";
        restart = "unless-stopped";

        environment = {
          TZ = "America/Sao_Paulo";
          GF_SECURITY_ADMIN_USER = "admin";
          GF_USERS_ALLOW_SIGN_UP = "false";
          GF_SERVER_ROOT_URL = "https://grafana-sc.alvesm.dev";
        };

        env_file = [
          grafanaPasswordEnvFile
        ];

        volumes = [
          "grafana_data:/var/lib/grafana"
          # Mount provisioning config from Nix store derivation
          "${grafanaProvisioningDir}:/etc/grafana/provisioning:ro"
        ];

        networks = [ "proxy" ];

        # Add host network access to reach Prometheus on host
        extra_hosts = [
          "host.docker.internal:host-gateway"
        ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.grafana.rule" = "Host(`grafana-sc.alvesm.dev`)";
          "traefik.http.routers.grafana.entrypoints" = "websecure";
          "traefik.http.routers.grafana.tls" = "true";
          "traefik.http.services.grafana.loadbalancer.server.port" = "3000";
        };
      };
    };
  };

  networks = {
    proxy = {
      name = "proxy";
    };
  };

  docker-compose = {
    volumes = {
      grafana_data = { };
    };
  };
}
