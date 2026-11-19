{ pkgs, lib, ... }:

{
  boot = {
    kernelParams = [ "quiet" ];

    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    loader = {
      # Lanzaboote replaces systemd-boot's direct management,
      # so we must disable it here.
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    # Lanzaboote Secure Boot configuration
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    initrd = {
      systemd = {
        contents."/etc/systemd/journald.conf".text = ''
          [Journal]
          ForwardToKMsg=yes
        '';
      };

      # Load kernel modules on boot.
      kernelModules = [ "amdgpu" ];
    };

    # Blacklist kernel modules at boot
    blacklistedKernelModules = [
      "asus_wmi"
      "eeepc_wmi"
    ];

    tmp.useTmpfs = true;
  };

  # sbctl is needed to create and manage Secure Boot keys
  environment.systemPackages = [
    pkgs.sbctl
  ];
}
