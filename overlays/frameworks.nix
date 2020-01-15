self: super:

let
  sources = import ../nix/sources.nix {};
in {
  my-python3Full = super.python3Full.withPackages (pypkgs: with pypkgs; [
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

    ptpython
  ]);

  niv = (import sources.niv {}).niv;
}
