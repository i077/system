self: super:

let
  nixpkgs-d244b77 = import
    (fetchTarball "https://github.com/NixOS/nixpkgs/archive/d244b77850263501c149435f2ff2de357b9db72c.tar.gz") {};
  
  trace = builtins.trace;
in
{
  # LDC does not build on current unstable
  ldc = trace "Currently overriding ldc" nixpkgs-d244b77.ldc;
  dmd = nixpkgs-d244b77.dmd;
}
