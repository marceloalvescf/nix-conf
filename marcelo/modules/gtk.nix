{ pkgs, ... }:

{
  gtk = {
    enable = true;
    colorScheme = "dark";

    cursorTheme = {
      package = pkgs.whitesur-cursors;
      name = "WhiteSur-cursors";
    };

    font = {
      name = "IBM Plex Sans";
      size = 10;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };

    # gtk3.extraConfig = {
    #   gtk-application-prefer-dark-theme = true;
    #   gtk-decoration-layout = "icon:minimize,maximize,close";
    #   gtk-enable-animations = true;
    # };

    # gtk4.extraConfig = {
    #   gtk-application-prefer-dark-theme = true;
    #   gtk-decoration-layout = "icon:minimize,maximize,close";
    #   gtk-enable-animations = true;
    # };
  };
}
