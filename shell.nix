with import <nixpkgs> { };

stdenv.mkDerivation {
  name = "dev";
  buildInputs = [
  	nixfmt
  ];
  shellHook = "";
}
