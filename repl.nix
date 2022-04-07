# repl.nix -- Provide commonly used values for the nix REPL
{ hostname ? "" }:

let
  flake = (builtins.getFlake (toString ./.));
  inherit (flake.inputs) nixpkgs;

  pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
in {
  # The flake itself
  inherit flake;
  inherit (flake) nixosConfigurations darwinConfigurations;

  # Nixpkgs
  inherit pkgs;
  inherit (pkgs) lib;

  # Config of the current system, if it exists
  inherit (flake.${
      if pkgs.stdenv.isDarwin then "darwinConfigurations" else "nixosConfigurations"
    }.${hostname})
    config;
}
