{ config, ... }:

{
  services = {
    prometheus = {
      enable = true;
      port = 9091;
      retentionTime = "7d";

      globalConfig = {
        scrape_interval = "30s";
        evaluation_interval = "30s";
      };

      scrapeConfigs = [
        {
          job_name = "prometheus";
          static_configs = [
            {
              targets = [ "localhost:9091" ];
            }
          ];
        }
        {
          job_name = "node_exporter";
          static_configs = [
            {
              targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
            }
          ];
        }
        {
          job_name = "docker";
          static_configs = [
            {
              targets = [ "localhost:9323" ];
            }
          ];
        }
      ];

      exporters = {
        node = {
          enable = true;
          port = 9100;
          enabledCollectors = [
            "systemd"
            "processes"
          ];
          # Optional: disable certain collectors
          # disabledCollectors = [ "textfile" ];
        };
      };
    };
  };

  # Open firewall ports for Grafana Datasource works
  networking.firewall.allowedTCPPorts = [ 9091 ];
}
