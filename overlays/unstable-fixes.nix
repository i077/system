self: super:

let
  trace = builtins.trace;
  nixpkgs-91fb0f2 = import
    (fetchTarball "https://github.com/NixOS/nixpkgs/archive/91fb0f2e4710d6a2f5e5cc55197afcddbd490c33.tar.gz") {};
in
{
  nixfmt = nixpkgs-91fb0f2.nixfmt;
}
