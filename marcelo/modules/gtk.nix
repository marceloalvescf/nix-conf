{ pkgs, ... }:

{
  # The theme, icon and cursor variants are owned by gnome-theme-follower, so
  # gtk.theme and friends must stay unset: they also write dconf on every switch.
  home.packages = with pkgs; [
    qogir-icon-theme
    qogir-theme
  ];

  gtk = {
    enable = true;
    font = {
      name = "SF Pro Text";
      size = 10;
    };

    gtk3.extraConfig = {
      gtk-decoration-layout = "icon:minimize,maximize,close";
      gtk-enable-animations = true;
    };

    gtk4 = {
      theme = null;
      extraConfig = {
        gtk-decoration-layout = "icon:minimize,maximize,close";
        gtk-enable-animations = true;
      };
    };
  };
}
