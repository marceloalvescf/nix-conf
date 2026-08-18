{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libGL,
  libgbm ? null,
  mesa,
  libnotify,
  libsecret,
  libusb1,
  libxkbcommon,
  nspr,
  nss,
  pango,
  systemd,
  xdg-utils,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
}:

let
  version = "26.814.41957";

  # This URL points at the latest release, while the fixed hash pins the
  # exact payload identified by `version` above. Update both together.
  src = fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb";
    hash = "sha256-R3iyanq9CGRyFNWwXBe9Pr4tlojRRtq/AXwaL6+TrH0=";
  };
in
stdenv.mkDerivation {
  pname = "chatgpt";
  inherit version src;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libGL
    (if libgbm != null then libgbm else mesa)
    libnotify
    libsecret
    libusb1
    libxkbcommon
    nspr
    nss
    pango
    systemd
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
  ];

  # These libraries are loaded dynamically and may not be detected by
  # autoPatchelf from the main executable's DT_NEEDED entries.
  runtimeDependencies = [
    (lib.getLib systemd)
    libsecret
    libusb1
  ];

  # The archive also contains optional Qt integration shims and prebuilt
  # Android/musl modules. They are not used by the x86_64 glibc application,
  # but autoPatchelf still discovers their foreign dependencies.
  autoPatchelfIgnoreMissingDeps = [
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
    "libQt6Core.so.6"
    "libQt6Gui.so.6"
    "libQt6Widgets.so.6"
    "libc++_shared.so"
    "libc.musl-x86_64.so.1"
    "libc.so"
    "libdl.so"
    "liblog.so"
    "libm.so"
  ];

  unpackPhase = ''
    runHook preUnpack
    ar x "$src"
    tar --no-same-owner --no-same-permissions -xf data.tar.xz
    runHook postUnpack
  '';

  # Apply the GTK wrapper arguments to the explicit wrapper below.
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r usr/lib "$out/lib"
    cp -r usr/share "$out/share"

    substituteInPlace "$out/share/applications/chatgpt.desktop" \
      --replace-fail 'Icon=chatgpt' \
        "Icon=$out/share/pixmaps/chatgpt.png"

    makeWrapper "$out/lib/chatgpt/ChatGPT" "$out/bin/chatgpt" \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib" \
      --add-flags "--ozone-platform-hint=auto"

    runHook postInstall
  '';

  meta = {
    description = "Desktop application for ChatGPT by OpenAI";
    homepage = "https://developers.openai.com/codex/app";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "chatgpt";
  };
}