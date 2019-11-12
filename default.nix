{ stdenvNoCC ? (import <nixpkgs> {}).stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "minidev";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    mkdir $out
    cp -R $src/dev.sh $src/bin $src/lib $src/vendor $out
    chmod +x $out/bin/dev
  '';
}
