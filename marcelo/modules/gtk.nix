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
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "icon:minimize,maximize,close";
      gtk-enable-animations = true;
    };

    gtk4 = {
      theme = null;
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-decoration-layout = "icon:minimize,maximize,close";
        gtk-enable-animations = true;
      };
    };
  };
}
