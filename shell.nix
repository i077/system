# Flake's devShell for non-flake-enabled nix instances
(import (fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz") {
  src = ./.;
}).shellNix.default
