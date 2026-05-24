{ ... }:

{
  project.name = "streaming";

  services = {
    qbittorrent = {
      service = {
        image = "lscr.io/linuxserver/qbittorrent:latest";
        container_name = "qbittorrent";
        restart = "unless-stopped";
        healthcheck = {
          test = [
            "CMD"
            "curl"
            "-fsS"
            "http://127.0.0.1:8080/api/v2/app/version"
            "https://icanhazip.com"
          ];
          interval = "5s";
          timeout = "5s";
          start_period = "30s";
          retries = 5;
        };

        environment = {
          "GUID" = "0";
          "PUID" = "0";
          "TZ" = "America/Sao_Paulo";
          "WEBUI_PORT" = "8080";
        };

        volumes = [
          "/home/marcelo/docker/streaming/configs/qbittorrent:/config"
          "/mnt/myexternaldisk/streaming/torrents:/data/torrents"
        ];

        networks = [ "proxy" ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.qbittorrent.rule" = "Host(`qbittorrent-sc.mapeus.xyz`)";
          "traefik.http.routers.qbittorrent.entrypoints" = "websecure";
          "traefik.http.routers.qbittorrent.tls" = "true";
          "traefik.http.services.qbittorrent.loadbalancer.server.port" = "8080";
        };
      };
    };

    radarr = {
      service = {
        image = "lscr.io/linuxserver/radarr:latest";
        container_name = "radarr";
        restart = "unless-stopped";
        healthcheck = {
          test = [
            "CMD"
            "curl"
            "-fsS"
            "http://127.0.0.1:7878/ping"
          ];
          interval = "5s";
          timeout = "5s";
          start_period = "30s";
          retries = 5;
        };

        depends_on = [ "qbittorrent" ];

        environment = {
          "GUID" = "0";
          "PUID" = "0";
          "TZ" = "America/Sao_Paulo";
        };

        volumes = [
          "/home/marcelo/docker/streaming/configs/radarr:/config"
          "/mnt/myexternaldisk/streaming:/data"
        ];

        networks = [ "proxy" ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.radarr.rule" = "Host(`radarr-sc.mapeus.xyz`)";
          "traefik.http.routers.radarr.entrypoints" = "websecure";
          "traefik.http.routers.radarr.tls" = "true";
          "traefik.http.services.radarr.loadbalancer.server.port" = "7878";
        };
      };
    };

    sonarr = {
      service = {
        image = "lscr.io/linuxserver/sonarr:latest";
        container_name = "sonarr";
        restart = "unless-stopped";
        healthcheck = {
          test = [
            "CMD"
            "curl"
            "-fsS"
            "http://127.0.0.1:8989/ping"
          ];
          interval = "5s";
          timeout = "5s";
          start_period = "30s";
          retries = 5;
        };

        depends_on = [ "qbittorrent" ];

        environment = {
          "GUID" = "0";
          "PUID" = "0";
          "TZ" = "America/Sao_Paulo";
        };

        volumes = [
          "/home/marcelo/docker/streaming/configs/sonarr:/config"
          "/mnt/myexternaldisk/streaming:/data"
        ];

        networks = [ "proxy" ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.sonarr.rule" = "Host(`sonarr-sc.mapeus.xyz`)";
          "traefik.http.routers.sonarr.entrypoints" = "websecure";
          "traefik.http.routers.sonarr.tls" = "true";
          "traefik.http.services.sonarr.loadbalancer.server.port" = "8989";
        };
      };
    };

    bazarr = {
      service = {
        image = "lscr.io/linuxserver/bazarr:latest";
        container_name = "bazarr";
        restart = "unless-stopped";
        healthcheck = {
          test = [
            "CMD"
            "curl"
            "-fsS"
            "http://127.0.0.1:6767/"
          ];
          interval = "5s";
          timeout = "5s";
          start_period = "30s";
          retries = 5;
        };

        environment = {
          "GUID" = "0";
          "PUID" = "0";
          "TZ" = "America/Sao_Paulo";
        };

        volumes = [
          "/home/marcelo/docker/streaming/configs/bazarr:/config"
          "/mnt/myexternaldisk/streaming/media:/data/media"
        ];

        networks = [ "proxy" ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.bazarr.rule" = "Host(`bazarr-sc.mapeus.xyz`)";
          "traefik.http.routers.bazarr.entrypoints" = "websecure";
          "traefik.http.routers.bazarr.tls" = "true";
          "traefik.http.services.bazarr.loadbalancer.server.port" = "6767";
        };
      };
    };

    flare-bypasser = {
      service = {
        image = "ghcr.io/yoori/flare-bypasser:latest";
        container_name = "flare-bypasser";
        restart = "unless-stopped";

        environment = {
          "UNUSED" = "false";
          "DEBUG" = "false";
          "VERBOSE" = "false";
          "SAVE_CHALLENGE_SCREENSHOTS" = "false";
        };

        networks = [ "proxy" ];
      };
    };

    prowlarr = {
      service = {
        image = "lscr.io/linuxserver/prowlarr:latest";
        container_name = "prowlarr";
        restart = "unless-stopped";
        healthcheck = {
          test = [
            "CMD"
            "curl"
            "-fsS"
            "http://127.0.0.1:9696/ping"
          ];
          interval = "5s";
          timeout = "5s";
          start_period = "30s";
          retries = 5;
        };

        environment = {
          "GUID" = "0";
          "PUID" = "0";
          "TZ" = "America/Sao_Paulo";
        };

        volumes = [
          "/home/marcelo/docker/streaming/configs/prowlarr:/config"
        ];

        networks = [ "proxy" ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.prowlarr.rule" = "Host(`prowlarr-sc.mapeus.xyz`)";
          "traefik.http.routers.prowlarr.entrypoints" = "websecure";
          "traefik.http.routers.prowlarr.tls" = "true";
          "traefik.http.services.prowlarr.loadbalancer.server.port" = "9696";
        };
      };
    };

    jellyfin = {
      service = {
        image = "lscr.io/linuxserver/jellyfin:latest";
        container_name = "jellyfin";
        restart = "unless-stopped";

        environment = {
          "GUID" = "0";
          "PUID" = "0";
          "TZ" = "America/Sao_Paulo";
        };

        volumes = [
          "/home/marcelo/docker/streaming/configs/jellyfin:/config"
          "/mnt/myexternaldisk/streaming/media:/data/media"
        ];

        networks = [ "proxy" ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.jellyfin.rule" = "Host(`jellyfin-sc.mapeus.xyz`)";
          "traefik.http.routers.jellyfin.entrypoints" = "websecure";
          "traefik.http.routers.jellyfin.tls" = "true";
          "traefik.http.services.jellyfin.loadbalancer.server.port" = "8096";
        };
      };
    };

    jellyseerr = {
      service = {
        image = "ghcr.io/seerr-team/seerr:latest";
        container_name = "jellyseerr";
        restart = "unless-stopped";
        healthcheck = {
          test = [
            "CMD"
            "wget"
            "http://127.0.0.1:5055/api/v1/status"
            "-qO"
            "/dev/null"
          ];
          interval = "5s";
          timeout = "5s";
          start_period = "30s";
          retries = 5;
        };

        environment = {
          "TZ" = "America/Sao_Paulo";
        };

        volumes = [
          "/home/marcelo/docker/streaming/configs/jellyseerr:/app/config"
        ];

        networks = [ "proxy" ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.jellyseerr.rule" = "Host(`jellyseerr-sc.mapeus.xyz`)";
          "traefik.http.routers.jellyseerr.entrypoints" = "websecure";
          "traefik.http.routers.jellyseerr.tls" = "true";
          "traefik.http.services.jellyseerr.loadbalancer.server.port" = "5055";
        };
      };
    };
  };

  networks = {
    proxy = {
      name = "proxy";
      external = true;
    };
  };
}
