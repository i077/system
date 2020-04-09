self: super:

let
  trace = builtins.trace;
  nixpkgs-f5a072b = import
    (fetchTarball "https://github.com/NixOS/nixpkgs/archive/f5a072bdf4e4efd362149721dcbd84ef28735069.tar.gz") {};
in
{
  # Building NVIDIA module is broken on 5.6 kernel, use 5.5 for now
  linuxPackages_latest = self.linuxPackages_5_5;
}
