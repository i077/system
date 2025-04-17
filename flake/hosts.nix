# This part is responsible for defining all host configurations (NixOS & nix-darwin) & deploy-rs
# options for the NixOS hosts.
{inputs, ...}: let
  inherit (inputs) self nixpkgs deploy-rs darwin home-manager;
  inherit (nixpkgs.lib) mkMerge;

  mkDarwinSystem = name: system: path: let
    systemArgs = isCi: {
      inherit system;
      modules = [
        home-manager.darwinModules.default
        ../modules/darwin
        path
        {lib.env.isCi = isCi;}
      ];
      specialArgs = {inherit inputs;};
    };
  in {
    # For each Darwin host, create two darwinSystems:
    # - one that targets the actual system, and
    darwinConfigurations.${name} = darwin.lib.darwinSystem (systemArgs false);
    # - one that is meant for CI, so that options defined with pkgs.requireFile can be skipped
    darwinConfigurations."${name}-ci" = darwin.lib.darwinSystem (systemArgs true);
  };

  # Create a nixosConfiguration output & deploy-rs node
  mkNixosDeployment = name: system: {
    nixosConfigurations.${name} = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [../modules/nixos ../modules/nixos/server.nix ../hosts/${name}];
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
  imports = let
    inherit (inputs.nixpkgs.lib) mkOption types;
  in [
    # Workaround to allow merging of flake's deploy option
    {options.flake.deploy = mkOption {type = types.lazyAttrsOf types.raw;};}
    {options.flake.darwinConfigurations = mkOption {type = types.lazyAttrsOf types.raw;};}
  ];

  flake = mkMerge [
    (mkNixosDeployment "cubone" "aarch64-linux")
    (mkNixosDeployment "combee" "x86_64-linux")
    (mkDarwinSystem "Venusaur" "aarch64-darwin" ../hosts/venusaur)
    (mkDarwinSystem "workmac" "aarch64-darwin" ../hosts/workmac)
    {
      checks =
        builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy)
        deploy-rs.lib;

      # Add my SSH keys to the lib set
      lib.mySshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQRxhrUwCg/DcNQfG8CwIMdJsHu0jZWI2BZV/T6ka5N"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsq7jgT0egpEZ4QpgaFHRRxrwk7vzWVvZE0w7Bhk9hK"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTgmWqiXS1b+l8KhvdrjZtbXXCh5UuBnbnase5601p2"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG13aSroi6VPpZII3u+0XkJyfE7ldbC6ovvMr3Fl6tMn"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1YIyqTUGvH71i6MWCsYPVoijYLZWfapmuMSR4aGAh9"
      ];
    }
  ];
}
