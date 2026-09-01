{ ... }:

{
  project.name = "autokube";

  services = {
    autokube = {
      service = {
        image = "autokubeio/autokube:latest";
        container_name = "autokube";
        restart = "unless-stopped";

        volumes = [
          "autokube_data:/data"
        ];

        networks = [ "proxy" ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.autokube.rule" = "Host(`autokube-sc.alvesm.dev`)";
          "traefik.http.routers.autokube.entrypoints" = "websecure";
          "traefik.http.routers.autokube.tls" = "true";
          "traefik.http.services.autokube.loadbalancer.server.port" = "8080";
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
      autokube_data = { };
    };
  };
}
