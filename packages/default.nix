{ lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      everdo = self.callPackage ./pkgs/everdo.nix { };
      obsidian = self.callPackage ./pkgs/obsidian.nix { };
      write_stylus = self.callPackage ./pkgs/write_stylus.nix { };
      nerdfonts-iosevka = self.callPackage ./pkgs/nerdfonts-iosevka.nix { };
    })
  ];
}
