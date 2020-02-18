let
  sources = import ../nix/sources.nix {};
in
[
  # Poetry2nix overlays
  (import (sources.poetry2nix + "/overlay.nix"))

  (import ./frameworks.nix)
  (import ./hardware.nix)
  (import ./my-pkgs.nix)
  (import ./unstable-fixes.nix)
]
