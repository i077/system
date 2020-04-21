self: super:

let
  trace = builtins.trace;
  importNixpkgsRev = { rev }: import (builtins.fetchTarball {
    name = "nixpkgs-src-" + rev;
    url = "https://github.com/NixOS/nixpkgs/archive/" + rev + ".tar.gz";
  }) { config = import ../nixpkgs-config.nix; overlays = []; };

  nixpkgs-a2d9f58 = importNixpkgsRev {
    rev = "a2d9f5843336b00398542448321a497309907d05";
  };
  nixpkgs-52f76b8 = importNixpkgsRev {
    rev = "52f76b890722878b068c95e562ed7c4c97752885";
  };
in
{
  # Building NVIDIA module is broken on 5.6 kernel, use 5.5 for now
  linuxPackages_latest = self.linuxPackages_5_5;

  inherit (nixpkgs-a2d9f58) onedrive;

  python3 = super.python3.override {
    packageOverrides = _: _: {
      inherit (nixpkgs-52f76b8.python3Packages) scipy scikitlearn;
    };
  };
}
