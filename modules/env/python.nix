{ config, pkgs, ... }:

let
  my-python3 = pkgs.python3Full.withPackages (pypkgs:
    with pypkgs; [
      matplotlib
      jupyter
      jupyterlab
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
in {
  home-manager.users.imran = {
    # Add python with custom set of packages
    home.packages = [ my-python3 ];
  };
}
