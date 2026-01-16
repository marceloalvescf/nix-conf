{ pkgs, inputs, ... }:

let
  cockpit-machines = import (inputs.self + "/pkgs/cockpit-machines/pkg.nix") {
    inherit (pkgs)
      lib
      stdenv
      fetchzip
      gettext
      ;
  };
  libvirt-dbus = import (inputs.self + "/pkgs/libvirt-dbus/pkg.nix") {
    inherit (pkgs)
      lib
      stdenv
      fetchFromGitLab
      meson
      pkg-config
      glib
      libvirt
      libvirt-glib
      docutils
      ninja
      ;
  };
in
{
  services.cockpit = {
    enable = true;
    openFirewall = true;
    port = 9090;
    allowed-origins = [
      "https://192.168.100.151:9090"
      "https://cockpit-sc.mapeus.xyz"
    ];
  };

  environment.systemPackages = [
    cockpit-machines
    libvirt-dbus
  ];
}
