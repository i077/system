self: super:

let
  trace = builtins.trace;
  nixpkgs-ddf87fb = import
    (fetchTarball "https://github.com/NixOS/nixpkgs/archive/ddf87fb1baf8f5022281dad13fb318fa5c17a7c6.tar.gz") {};
in
{
  vimPlugins = nixpkgs-ddf87fb.vimPlugins;
}
