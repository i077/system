{ device, lib, inputs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      everdo = self.callPackage ./pkgs/everdo.nix { };
      write_stylus = self.callPackage ./pkgs/write_stylus.nix { };
      nerdfonts-iosevka = self.callPackage ./pkgs/nerdfonts-iosevka.nix { };

      neuron = import inputs.neuron {
        inherit (device) system;
      };
    })
  ];
}
