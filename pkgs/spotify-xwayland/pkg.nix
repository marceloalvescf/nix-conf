{ pkgs, ... }:

pkgs.runCommand "spotify-xwayland-${pkgs.spotify.version}"
  {
    nativeBuildInputs = [ pkgs.makeWrapper ];
    meta = pkgs.spotify.meta // {
      description = "${pkgs.spotify.meta.description} (forced through XWayland on GNOME)";
      mainProgram = "spotify";
    };
  }
  ''
    mkdir -p $out/bin $out/share/applications $out/share/icons

    makeWrapper ${pkgs.spotify}/bin/spotify $out/bin/spotify \
      --set NIXOS_OZONE_WL 0 \
      --add-flags "--ozone-platform=x11"

    cp ${pkgs.spotify}/share/applications/spotify.desktop \
      $out/share/applications/spotify.desktop
    ln -s ${pkgs.spotify}/share/icons/* $out/share/icons/
  ''
