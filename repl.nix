# repl.nix -- Provide commonly used values for the nix REPL
{ hostname ? "" }:

let
  flake = (builtins.getFlake (toString ./.));
  inherit (flake.inputs) nixpkgs;
in {
  # The flake itself
  inherit flake;
  inherit (flake) nixosConfigurations;

  # Nixpkgs
  pkgs = nixpkgs.legacyPackages.${builtins.currentSystem}; # TODO Remove impurity
  lib = nixpkgs.lib // { mine = flake.lib; };

  # Config of the current system, if it exists
  inherit (flake.nixosConfigurations.${hostname}) config;
}
