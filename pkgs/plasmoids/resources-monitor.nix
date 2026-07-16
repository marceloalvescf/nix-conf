{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "plasmoid-resources-monitor";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "orblazer";
    repo = "plasma-applet-resources-monitor";
    rev = "v3.2.1";
    hash = "sha256-uP1TjH7vFIB9DO9SJXOLsQGQ7CRjGNuPY8c4vszIHmk=";
  };

  # Root Makefile is dev tooling; nothing to compile.
  dontBuild = true;

  # Install dir must match KPlugin.Id for KPackage discovery.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/org.kde.plasma.resources-monitor
    cp -r package/. $out/share/plasma/plasmoids/org.kde.plasma.resources-monitor
    runHook postInstall
  '';

  meta = {
    description = "Plasma widget for monitoring CPU, memory, network, GPU and disk IO";
    homepage = "https://github.com/orblazer/plasma-applet-resources-monitor";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
