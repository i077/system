{ ... }:

{
  imports = [
    ./backup.nix
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./nixpkgs.nix
    ./power.nix
    ./printing.nix
    ./private.nix
    ./services.nix
    ./theming.nix
    ./users.nix
    ./xserver.nix
    ./yubikey.nix
  ];
}
