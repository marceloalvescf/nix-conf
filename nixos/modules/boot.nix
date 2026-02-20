{ pkgs, lib, ... }:

{
  boot = {
    kernelParams = [ "quiet" ];

    # Using linux-zen kernel
    kernelPackages = pkgs.linuxPackages_zen;

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

    # Load kernel modules on boot.
    initrd.kernelModules = [
      "amdgpu"
    ];

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
