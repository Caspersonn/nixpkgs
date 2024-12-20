{ appimageTools, fetchurl , lib }:
let
  pname = "quiqr";
  version = "0.18.11";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/quiqr/quiqr-desktop/releases/download/v${version}/quiqr_${version}_linux_x86_64.AppImage";
    hash = "sha256-y9uIS84zu218+UAMOzO1ezPDcGFhismcXKlgPGJfn2M=";
  };

appimageContents = appimageTools.extractType1 { inherit pname version src; };
in
appimageTools.wrapType1 {
  inherit pname name version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Offline CMS with a Hugo Engine";
    homepage = "https://github.com/quiqr/quiqr-desktop";
    downloadPage = "https://github.com/quiqr/quiqr-desktop/releases";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
