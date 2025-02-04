{ stdenv }:

stdenv.mkDerivation {
  name = "my-images";
  version = "1.0.0";

  src = ./resources/.; # Use current directory as source

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/share/my-images
    cp * $out/share/my-images/
  '';
}
