{
  description = "My Nix configurations";
  
  inputs = {
    # Use unstable-small branch for quicker updates
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    
    # A nicer developer env experience
    devshell.url = "github:numtide/devshell";
    
    # Easily deploy changes to systems
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, deploy-rs, devshell, ... }@inputs: let 
    # Systems supported by this flake
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in {
    nixosConfigurations = {
      cubone = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/cubone ];
      };
    };
    
    deploy.nodes = {

    };
    
    devShell = forAllSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ devshell.overlay ];
      };
      in pkgs.devshell.mkShell {
        name = "system";
        packages = with pkgs; [
          # Wrap nix to support flakes
          (writeShellScriptBin "nix" ''
            ${pkgs.nix_2_4}/bin/nix --option experimental-features "nix-command flakes" "$@"
          '')
          nixfmt
        ];
      });
  };
}
