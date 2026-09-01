{ ... }:

{
  project.name = "portainer";

  services = {
    portainer = {
      service = {
        image = "portainer/portainer-ce:lts";
        container_name = "portainer";
        restart = "unless-stopped";

        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock:ro"
          "portainer_data:/data"
        ];

        networks = [ "proxy" ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.portainer.rule" = "Host(`portainer-sc.alvesm.dev`)";
          "traefik.http.routers.portainer.entrypoints" = "websecure";
          "traefik.http.routers.portainer.tls" = "true";
          "traefik.http.services.portainer.loadbalancer.server.port" = "9000";
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
      portainer_data = { };
    };
  };
}
