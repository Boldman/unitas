with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "unitas-config";
  buildInputs = [
  	nixfmt
  ];
  shellHook = "echo ${stdenv.mkDerivation.name}";
}
