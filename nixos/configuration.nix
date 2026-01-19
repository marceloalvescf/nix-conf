# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Run Nix-based projects in Docker Compose using Arion
    ./modules/arion/arion.nix

    # Boot config
    ./modules/boot.nix

    # Cockpit config
    ./modules/cockpit.nix

    # Font config
    ./modules/fonts.nix

    # Hardware config
    ./modules/hardware.nix

    # Network config
    ./modules/networking.nix

    # OpenRGB config
    ./modules/openrgb.nix

    # Plasma config
    ./modules/plasma.nix

    # Program and package config
    ./modules/packages.nix

    # Prometheus related config
    ./modules/prometheus.nix

    # SOPS config
    ./modules/secrets.nix

    # Services config
    ./modules/services.nix

    # System config
    ./modules/system.nix

    # Users config
    ./modules/users.nix

    # Virtualization config
    ./modules/virtualisation.nix
  ];

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Nixpkgs related settings
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
