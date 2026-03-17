{ pkgs, ... }:

let
  pname = "lens-desktop";
  version = "2026.3.160808";

  src = pkgs.fetchurl {
    url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.x86_64.AppImage";
    sha256 = "sha256-P0WAjgll5JBqy+vVHWwCzcK/pwT6CqHbDPLOkbdBEzo=";
  };

  meta = {
    description = "Kubernetes IDE";
    homepage = "https://k8slens.dev/";
    # license = licenses.unfree; # Lens is not FOSS
    platforms = [ "x86_64-linux" ];
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };
in
pkgs.appimageTools.wrapType2 {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -m 444 -D ${appimageContents}/${pname}.desktop \
      $out/share/applications/${pname}.desktop

    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/${pname}.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' "Exec=${pname}"
  '';

  extraPkgs = pkgs: [ pkgs.nss_latest ];
}
