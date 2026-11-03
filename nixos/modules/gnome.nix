{ pkgs, ... }:

{
  services = {
    # Disable X11
    xserver.enable = false;

    # Install GNOME
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };

    # gpg-agent serves SSH_AUTH_SOCK instead (marcelo/modules/gpg.nix)
    gnome.gcr-ssh-agent.enable = false;
  };

  # Remove unnecessary GNOME packages
  environment.gnome.excludePackages = with pkgs; [
    decibels
    epiphany
    geary
    gnome-connections
    gnome-console
    gnome-contacts
    gnome-logs
    gnome-maps
    gnome-music
    gnome-terminal
    gnome-tour
    gnome-user-docs
    gnome-user-share
    showtime
    simple-scan
    totem
    yelp
  ];
}
