{ pkgs, ... }:

let
  pname = "codex";
  version = "0.132.0";

  src = pkgs.fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-x86_64-unknown-linux-musl.tar.gz";
    sha256 = "sha256-i2RDLuTvWx19GXqtRTWidryFIj9OQWN2nA4QFc2og7I=";
  };
in
pkgs.stdenvNoCC.mkDerivation {
  inherit pname version src;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -m 755 -D codex-x86_64-unknown-linux-musl $out/bin/codex

    runHook postInstall
  '';

  meta = {
    description = "Coding agent from OpenAI that runs locally";
    homepage = "https://github.com/openai/codex";
    license = pkgs.lib.licenses.asl20;
    mainProgram = "codex";
    platforms = [ "x86_64-linux" ];
  };
}
