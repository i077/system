inputs@{ nixpkgs, devshell, sops-nix, treefmt, ... }:
system:
let
  pkgs = import nixpkgs {
    inherit system;
    overlays = [ devshell.overlay ];
  };

  inherit (pkgs) lib;

  nixBin = pkgs.writeShellScriptBin "nix" ''
    ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in pkgs.devshell.mkShell {
  name = "system-shell";

  env = let nv = lib.nameValuePair;
  in [
    # Export PGP keys for sops
    (nv "sopsPGPKeyDirs"
      ''"$DEVSHELL_ROOT/secrets/pubkeys/hosts" "$DEVSHELL_ROOT/secrets/pubkeys/users"'')
    {
      name = "PATH";
      prefix = "bin";
    }
  ];

  packages = with pkgs; [
    sops-nix.packages.${system}.sops-pgp-hook
    fish
    git
    gnupg
    nixBin
    restic
    utillinux

    # Formatters used by treefmt
    luaformatter
    nixfmt
    nodePackages.prettier
  ];

  commands = [
    # Packages
    { package = pkgs.sops; }
    { package = pkgs.gitAndTools.gh; }
    {
      help = "Format the entire code tree";
      category = "formatters";
      package = treefmt.defaultPackage.${system};
    }

    # Custom commands
    {
      name = "update-pr";
      help = "View the latest flakebot PR";
      category = "maintenance";
      command = "${pkgs.gitAndTools.gh}/bin/gh pr view -c flakebot";
    }
    {
      name = "secrets";
      help = "Edit secrets.yaml with sops";
      category = "maintenance";
      command = "${pkgs.sops}/bin/sops secrets/secrets.yaml";
    }
  ];
}
