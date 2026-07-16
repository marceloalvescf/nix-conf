{ pkgs, ... }:

{
  services = {
    # Disable X11
    xserver.enable = false;

    # Install Plasma 6
    displayManager.sddm = {
      enable = true;
      wayland = {
        enable = true;
      };
    };
    desktopManager.plasma6.enable = true;
  };

  environment.systemPackages = with pkgs.kdePackages; [
    kamoso
    kcalc
  ];

  # Remove unnecessary Plasma packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    dolphin-plugins
    elisa
    khelpcenter
    konsole
    plasma-browser-integration
  ];
}
