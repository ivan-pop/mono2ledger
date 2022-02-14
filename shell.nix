with import <nixpkgs> {};
let
  python = python38.withPackages (pkgs: with pkgs; [
  ]);
in mkShell {
  buildInputs = [
    python
    black
  ];
}
