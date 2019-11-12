{ stdenvNoCC ? (import <nixpkgs> {}).stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "minidev";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin $out/share/minidev
    cp $src/exe/dev $out/bin/dev
    chmod +x $out/bin/dev
    cp -R $src/dev.sh $src/lib $src/vendor $out
  '';
}
