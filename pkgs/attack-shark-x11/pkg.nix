{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  electron_42,
  makeWrapper,
  autoPatchelfHook,
  jq,
}:

buildNpmPackage {
  pname = "attack-shark-x11";
  version = "1.4.2-unstable-2026-07-26";

  # Pinned to main rather than the v1.4.2 tag: the tag still pulls `usb` from a
  # GitHub branch, while main takes it from the registry as prebuilt napi-rs
  # binaries, which is what makes this buildable without network access.
  src = fetchFromGitHub {
    owner = "dressedinblack5";
    repo = "attack-shark-x11-electron";
    rev = "ecc4f2ad3a90f1990c201c84260d226a3220bc83";
    hash = "sha256-wmo4c4MOMW/9fjAgY3XI4pjfaKyoqy0lVhXSIDRfbaU=";
  };

  # Upstream ships only bun.lock. Regenerate with:
  #   npm install --package-lock-only --ignore-scripts --legacy-peer-deps
  #
  # `npm rebuild` runs the root install scripts: electron's postinstall fetches a
  # prebuilt binary (v42 dropped the ELECTRON_SKIP_BINARY_DOWNLOAD escape hatch)
  # and husky's prepare wants a git checkout. The nixpkgs electron replaces the
  # former and neither is needed to build, so drop both.
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    jq 'del(.scripts.postinstall, .scripts.prepare)' package.json > package.json.new
    mv package.json.new package.json

    # The DevTools call is gated on @electron-toolkit's `is.dev`, which is just
    # `!app.isPackaged`. Electron only sets isPackaged for an asar/renamed
    # binary, never when run against a plain app directory as it is here, so
    # without this the window always comes up with DevTools open.
    substituteInPlace src/main/index.ts \
      --replace-fail "mainWindow.webContents.openDevTools();" ""
  '';

  npmDepsHash = "sha256-CijCAkLMQlg6gOw/gXRmmyTDl/g/jyPcYprJEEDEd38=";

  # electron-vite 5 declares a peer range of vite ^5||^6||^7 while upstream
  # pins vite 8. bun tolerates the mismatch, npm aborts without this.
  npmFlags = [ "--legacy-peer-deps" ];

  nativeBuildInputs = [
    autoPatchelfHook
    jq
    makeWrapper
  ];

  # libgcc_s for the prebuilt usb.linux-x64-gnu.node.
  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  installPhase =
    let
      appDir = "$out/share/attack-shark-x11";
    in
    ''
      runHook preInstall

      mkdir -p "${appDir}"
      cp -r out package.json assets "${appDir}/"

      # electron-vite keeps the main/preload dependencies external, so `usb` and
      # @electron-toolkit/utils have to exist at runtime; everything else the app
      # imports is bundled into out/.
      mkdir -p "${appDir}/node_modules/@node-usb" "${appDir}/node_modules/@electron-toolkit"
      cp -r node_modules/usb "${appDir}/node_modules/"
      cp -r node_modules/@node-usb/. "${appDir}/node_modules/@node-usb/"
      cp -r node_modules/@electron-toolkit/utils "${appDir}/node_modules/@electron-toolkit/"

      install -Dm644 assets/atackshark.png "$out/share/pixmaps/attack-shark-x11.png"

      # Icon= is an absolute store path because a home-manager profile install
      # never regenerates the GNOME icon theme cache, so a bare name resolves to
      # a missing launcher icon.
      mkdir -p "$out/share/applications"
      cat > "$out/share/applications/attack-shark-x11.desktop" <<EOF
      [Desktop Entry]
      Type=Application
      Name=Attack Shark X11
      Comment=Configure DPI, polling rate, macros and lighting on the Attack Shark X11 mouse
      Exec=attack-shark-x11
      Icon=$out/share/pixmaps/attack-shark-x11.png
      Terminal=false
      Categories=Settings;HardwareSettings;
      Keywords=mouse;dpi;gaming;
      EOF

      makeWrapper "${lib.getExe electron_42}" "$out/bin/attack-shark-x11" \
        --add-flags "${appDir}" \
        --add-flags "--ozone-platform-hint=auto" \
        --inherit-argv0

      runHook postInstall
    '';

  meta = {
    description = "Desktop configuration app for the Attack Shark X11 gaming mouse";
    homepage = "https://github.com/dressedinblack5/attack-shark-x11-electron";
    license = lib.licenses.mit;
    sourceProvenance = [
      lib.sourceTypes.fromSource
      lib.sourceTypes.binaryNativeCode # prebuilt napi-rs usb binding
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "attack-shark-x11";
  };
}
