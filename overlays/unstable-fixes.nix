self: super:

let
  importNixpkgsRev = { rev }: import (builtins.fetchTarball {
    name = "nixpkgs-src-" + rev;
    url = "https://github.com/NixOS/nixpkgs/archive/" + rev + ".tar.gz";
  }) { config = import ../nixpkgs-config.nix; overlays = []; };

  nixpkgs-b3c3a0b = importNixpkgsRev { rev = "b3c3a0bd1835a3907bf23f5f7bd7c9d18ef163ec"; };
in
{
  inherit (nixpkgs-b3c3a0b) quodlibet-full;
}
