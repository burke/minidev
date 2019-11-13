{ stdenvNoCC ? (import <nixpkgs> {}).stdenvNoCC
, ruby       ? (import <nixpkgs> {}).ruby
}:
stdenvNoCC.mkDerivation {
  pname = "minidev";
  version = "1.0.0";

  src = ./.;

  buildInputs = [ ruby ];

  installPhase = ''
    mkdir $out
    cp -R $src/dev.sh $src/bin $src/lib $src/vendor $out
    chmod +x $out/bin/dev
  '';
}
