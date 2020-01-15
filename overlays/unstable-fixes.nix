self: super:

let
  nixpkgs-d244b77 = import
    (fetchTarball "https://github.com/NixOS/nixpkgs/archive/d244b77850263501c149435f2ff2de357b9db72c.tar.gz") {};
  
  trace = builtins.trace;
in
{
}
