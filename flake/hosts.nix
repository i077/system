# This part is responsible for defining all host configurations (NixOS & nix-darwin) & deploy-rs
# options for the NixOS hosts.
{inputs, ...}: let
  inherit (inputs) self nixpkgs deploy-rs darwin home-manager;
  inherit (nixpkgs.lib) mkMerge;

  mkDarwinConfig = system: path:
    darwin.lib.darwinSystem {
      inherit system;
      modules = [home-manager.darwinModule ../modules/darwin path];
      specialArgs = {inherit inputs;};
    };

  # Create a nixosConfiguration output & deploy-rs node
  mkNixosDeployment = name: system: {
    nixosConfigurations.${name} = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [../modules/nixos ../hosts/${name}];
      specialArgs = {inherit inputs;};
    };
    deploy.nodes.${name} = {
      hostname = name;
      sshUser = "imran";
      user = "root";
      profiles.system.path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${name};
    };
  };
in {
  imports = [
    # Workaround to allow merging of flake's deploy option
    {options.flake.deploy = inputs.nixpkgs.lib.mkOption {type = inputs.nixpkgs.lib.types.anything;};}
  ];
  flake = mkMerge [
    (mkNixosDeployment "cubone" "aarch64-linux")
    (mkNixosDeployment "staryu" "x86_64-linux")
    {
      darwinConfigurations = {
        NTC-MacBook = mkDarwinConfig "x86_64-darwin" ../hosts/ntc-macbook;
        Venusaur = mkDarwinConfig "aarch64-darwin" ../hosts/venusaur;
      };

      checks =
        builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy)
        deploy-rs.lib;
    }
  ];
}
