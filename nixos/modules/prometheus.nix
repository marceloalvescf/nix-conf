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
        {
          job_name = "libvirt_exporter";
          static_configs = [
            {
              targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.libvirt.port}" ];
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
        libvirt = {
          enable = true;
          listenAddress = "127.0.0.1";
          port = 9177;
          libvirtUri = "qemu:///system";
        };
      };
    };
  };

  # Libvirt uses polkit, which needs persistent group membership for the exporter.
  users.users.${config.services.prometheus.exporters.libvirt.user} = {
    isSystemUser = true;
    group = config.services.prometheus.exporters.libvirt.group;
    extraGroups = [ "libvirtd" ];
  };
  users.groups.${config.services.prometheus.exporters.libvirt.group} = { };

  systemd.services.prometheus-libvirt-exporter = {
    after = [ "libvirtd.service" ];
    wants = [ "libvirtd.service" ];
    serviceConfig.DynamicUser = false;
  };

  # Open firewall ports for Grafana Datasource works
  networking.firewall.allowedTCPPorts = [ 9091 ];
}
