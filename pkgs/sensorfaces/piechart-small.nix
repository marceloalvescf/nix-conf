{
  lib,
  runCommand,
  jq,
  kdePackages,
}:

let
  id = "starscream.ksysguard.piechart-small";
in
runCommand "sensorface-piechart-small-${kdePackages.libksysguard.version}"
  {
    nativeBuildInputs = [ jq ];
    meta = {
      description = "Plasma Pie Chart sensor face with the center value 2pt smaller";
      license = lib.licenses.lgpl2Plus;
      platforms = lib.platforms.linux;
    };
  }
  ''
    face=$out/share/ksysguard/sensorfaces/${id}
    mkdir -p $(dirname $face)
    cp -r ${kdePackages.libksysguard}/share/ksysguard/sensorfaces/org.kde.ksysguard.piechart $face
    chmod -R u+w $face

    # Stock face has no font option; the center value inherits the default font.
    substituteInPlace $face/contents/ui/UsedTotalDisplay.qml \
      --replace-fail "id: usedValue" "id: usedValue
                font.pointSize: Kirigami.Theme.defaultFont.pointSize - 2"

    jq '.KPlugin |= (with_entries(select(.key | startswith("Name[") | not))
          | .Id = "${id}" | .Name = "Pie Chart (small text)")' \
      $face/metadata.json > metadata.json
    mv metadata.json $face/metadata.json
  ''
