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

  my-python3-i3 = super.python3Full.withPackages (pypkgs: with pypkgs; [
    i3ipc
  ]);

  niv = (import sources.niv {}).niv;
}
