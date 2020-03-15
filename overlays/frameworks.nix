self: super:

let
  sources = import ../nix/sources.nix {};
in {
  my-python3Full = super.python3Full.withPackages (pypkgs: with pypkgs; [
    matplotlib
    jupyter jupyterlab
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

  my-python3-i3 = super.python3.withPackages (pypkgs: with pypkgs; [
    i3ipc
  ]);

  jupyterWith = (import sources.jupyterWith {});

  niv = (import sources.niv {}).niv;
}
