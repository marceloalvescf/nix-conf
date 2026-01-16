{ traefikEnvFile, traefikConfigDir, ... }:

{
  project.name = "traefik";

  services = {
    traefik = {
      service = {
        image = "traefik:v3.6.7";
        container_name = "traefik";
        restart = "unless-stopped";
        environment = {
          TZ = "America/Sao_Paulo";
        };

        env_file = [
          traefikEnvFile
        ];

        ports = [
          "80:80"
          "443:443"
          "8080:8080"
        ];

        volumes = [
          # Mount config from a proper derivation - this ensures the store
          # path is tracked as a dependency and won't be garbage collected
          "${traefikConfigDir}:/etc/traefik:ro"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
          "certs:/certs"
        ];

        networks = [ "proxy" ];
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
      certs = { };
    };
  };
}
