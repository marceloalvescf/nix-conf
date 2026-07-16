{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "plasmoid-weather-widget-plus";
  version = "4.7";

  src = fetchFromGitHub {
    owner = "tully-t";
    repo = "weather-widget-plus";
    rev = "v4.7";
    hash = "sha256-2KHhoi2N9pe3+cWh304vR632Q8i6oh2jwfuBOtcmyNU=";
  };

  dontBuild = true;

  # Install dir must match KPlugin.Id for KPackage discovery.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/weather.widget.plus
    cp -r weather.widget.plus/. $out/share/plasma/plasmoids/weather.widget.plus
    runHook postInstall
  '';

  meta = {
    description = "Plasma widget showing weather information from Met.no and Open-Meteo";
    homepage = "https://github.com/tully-t/weather-widget-plus";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
