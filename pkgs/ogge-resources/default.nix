{ stdenv }:

stdenv.mkDerivation {
  name = "ogge-resources";
  version = "1.0.0";

  src = ./resources/.; # Use current directory as source

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/share/ogge-resources
    cp * $out/share/ogge-resources/
  '';
}
