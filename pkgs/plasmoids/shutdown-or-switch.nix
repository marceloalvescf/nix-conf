{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "plasmoid-shutdown-or-switch";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "Davide-sd";
    repo = "shutdown_or_switch";
    rev = "v1.1.5";
    hash = "sha256-y/Zho8lWeVjItD3FGC2dg8rFynhR3PlCD2iSa2ZE+4k=";
  };

  dontBuild = true;

  # Install dir must match KPlugin.Id for KPackage discovery.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/org.kde.plasma.shutdownorswitch
    cp -r package/. $out/share/plasma/plasmoids/org.kde.plasma.shutdownorswitch
    runHook postInstall
  '';

  meta = {
    description = "Plasma widget with a single menu for lock, logout, suspend, reboot and shutdown";
    homepage = "https://github.com/Davide-sd/shutdown_or_switch";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
