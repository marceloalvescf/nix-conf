{ pkgs, ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
      daemon = {
        settings = {
          "experimental" = true;
        };
      };
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = (
          pkgs.qemu_kvm.override {
            enableDocs = false;
            cephSupport = false;
          }
        );
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
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
