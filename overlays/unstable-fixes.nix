self: super:

let
  nixpkgs-100012e = import
    (fetchTarball "https://github.com/NixOS/nixpkgs/archive/100012e55bc2a82fc680cba31a426ad38ead6fab.tar.gz") {};
  
  trace = builtins.trace;
in
{
  onedrive = nixpkgs-100012e.onedrive;
}
