let sources = import ../nix/sources.nix { };
in import (sources.poetry2nix + "/overlay.nix")
