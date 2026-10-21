{ pkgs, ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
      logDriver = "json-file";
      daemon = {
        settings = {
          "experimental" = true;
          "metrics-addr" = "127.0.0.1:9323";
          # Applies only to containers created after the daemon restarts.
          "log-opts" = {
            "max-size" = "10m";
            "max-file" = "3";
          };
        };
      };
    };

    libvirtd = {
      enable = true;
      dbus.enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
  };

  services.cockpit = {
    enable = true;
    openFirewall = true;
    port = 9090;
    allowed-origins = [
      "https://192.168.100.151:9090"
      "https://cockpit-sc.alvesm.dev"
    ];
    plugins = [
      pkgs.cockpit-machines
    ];
  };

  # Allow traffic from Docker networks through the firewall
  networking.firewall = {
    trustedInterfaces = [
      "docker0"
      "br-+"
      "veth+"
    ];
    # Required for container networking - allows packets from containers
    # to be routed back correctly
    checkReversePath = "loose";
  };
}
