{ lib, buildNpmPackage, fetchFromGitHub, fetchurl, electron, embgit, git }:

buildNpmPackage rec {
  pname = "quiqr-desktop";
  version = "0.18.11";

  src = fetchFromGitHub {
    owner = "quiqr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-amcJ94TjndJE7WNdbrf6DFTLugG77hkhD9mAmbchE7A=";
  };

  nativeBuildInputs = [
    electron
    embgit
    git
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
    NODE_OPTIONS = "--openssl-legacy-provider";
    EMBGIT_PATH="${embgit}/bin/embgit";
  };

 # postInstall = ''
 #   makeWrapper ${nix}/bin/nix $out/bin/quiqr \
 #     --add-flags "develop"
 # '';

  npmDepsHash = "sha256-B0PAk75ESmjUPusaLL70B6ZtwuemWY4+oeQhZegYfzk=";

  #npmFlags = [ "--ignore-scripts" ];

  #dontNpmBuild = true;

  meta = {
    description = "Offline CMS with a Hugo Engine";
    homepage = "https://quiqr.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caspersonn ];
  };
}
