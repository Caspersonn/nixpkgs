{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  wget,
  jq,
  curl,
}:

let
  version = "1.0-alpha";
in
stdenv.mkDerivation {
  pname = "hedgedoc-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "hedgedoc";
    repo = "cli";
    rev = "defeac80ca97fedcb19bdcddc516fd8f6e55fe8c";
    sha256 = "sha256-7E5Ka6SEPRg2O4+bJ6g3gSDMLnPMzg5Lbslgvt6gNEg=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src/bin/codimd $out/bin
    wrapProgram $out/bin/codimd \
      --prefix PATH : ${
        lib.makeBinPath [
          jq
          wget
          curl
        ]
      }
    ln -s $out/bin/codimd $out/bin/hedgedoc-cli
    runHook postInstall
  '';

  checkPhase = ''
    hedgedoc-cli help
  '';

  meta = with lib; {
    description = "Hedgedoc CLI";
    homepage = "https://github.com/hedgedoc/cli";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ drupol Caspersonn ];
  };
}
