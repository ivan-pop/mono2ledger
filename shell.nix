with import <nixpkgs> {};
mkShell {
  buildInputs = [
    python38
    black
  ];
}
