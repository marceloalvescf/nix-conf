{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.astra-monitor
    gnomeExtensions.bluetooth-battery-meter
    gnomeExtensions.blur-my-shell
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.simpleweather
    gnome-extension-manager
    gnome-shell-extensions
    gnome-tweaks
    nautilus
    resources
  ];

  imports = [
    ./dconf.nix
  ];
}
