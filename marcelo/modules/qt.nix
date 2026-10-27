{ pkgs, ... }:

{
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "kvantum";
  };

  # gnome-theme-follower writes Kvantum/kvantum.kvconfig to switch the Qogir
  # light/dark variant. qt.kvantum always manages that file, so link the themes
  # file by file instead and leave the directory writable.
  xdg.configFile."Kvantum" = {
    source = "${pkgs.qogir-kde}/share/Kvantum";
    recursive = true;
  };
}
