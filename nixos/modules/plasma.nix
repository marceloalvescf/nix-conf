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
      settings = {
        General = {
          DisplayServer = "Wayland";
        };
      };
    };
    desktopManager.plasma6.enable = true;
  };

  # Remove unnecessary Plasma packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    dolphin-plugins
    elisa
    khelpcenter
    konsole
    plasma-browser-integration
  ];
}
