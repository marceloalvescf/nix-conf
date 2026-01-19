{ pkgs, ... }:

{
  services = {
    hardware = {
      openrgb = {
        enable = true;
        package = pkgs.openrgb-with-all-plugins;
        motherboard = "amd";
      };
    };
  };

  environment.systemPackages = [
    pkgs.openrgb-with-all-plugins
  ];
}
