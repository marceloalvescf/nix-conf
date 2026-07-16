{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "plasmoid-andromeda-launcher";
  version = "0.6-unstable-2026-03-25";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "AndromedaLauncher";
    rev = "6bd0ac49b60888dd502169b0eacf5ca5146b1ec1";
    hash = "sha256-MSYD8eH6m4vWfvoAfHkqMed+ZGjFE0Ln75cqIZYq9Eg=";
  };

  dontBuild = true;

  # Install dir must match KPlugin.Id for KPackage discovery.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/AndromedaLauncher
    cp -r . $out/share/plasma/plasmoids/AndromedaLauncher
    runHook postInstall
  '';

  meta = {
    description = "Modern launcher widget for KDE Plasma";
    homepage = "https://github.com/EliverLara/AndromedaLauncher";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
