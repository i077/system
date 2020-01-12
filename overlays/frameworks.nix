self: super:

let
  sources = import ../nix/sources.nix {};
  unstable = import sources.nixpkgs-unstable {};
in {
  my-python3Full = super.python3Full.withPackages (ps: with ps; [
    matplotlib
    notebook
    numpy
    rope
    setuptools
    scipy
    scikitlearn
    sympy
    cython
    jedi
    python-language-server
  ]);

  niv = (import sources.niv {}).niv;
}
