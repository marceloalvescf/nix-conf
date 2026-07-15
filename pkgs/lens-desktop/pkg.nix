{ pkgs, ... }:

let
  pname = "lens-desktop";
  version = "2026.5.250609";

  src = pkgs.fetchurl {
    url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.x86_64.AppImage";
    sha256 = "sha256-cd+m3vqC2NMqEQ43yh8mSd6vfeWjQYU3T6szhc/myVc=";
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
      --replace-fail 'Exec=AppRun' "Exec=${pname}" \
      --replace-fail 'Icon=lens-desktop' "Icon=$out/share/icons/hicolor/512x512/apps/${pname}.png" \
      --replace-fail 'StartupWMClass=Lens' 'StartupWMClass=lens'
  '';

  extraPkgs = pkgs: [ pkgs.nss_latest ];
}
