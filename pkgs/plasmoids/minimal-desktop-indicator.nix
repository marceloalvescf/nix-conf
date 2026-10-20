{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "plasmoid-minimal-desktop-indicator";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "DualityKyle";
    repo = "plasma-desktop-indicator";
    rev = "26.10.08";
    hash = "sha256-SOHDKJUeuVhxul6NtFa3j0uvP6+dwCw6vHRbRSGOW7M=";
  };

  dontBuild = true;

  # Install dir must match KPlugin.Id for KPackage discovery.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/com.github.dualitykyle.desktopindicator
    cp -r metadata.json contents $out/share/plasma/plasmoids/com.github.dualitykyle.desktopindicator
    runHook postInstall
  '';

  meta = {
    description = "Plasma virtual desktop indicator using simple dots";
    homepage = "https://github.com/DualityKyle/plasma-desktop-indicator";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
