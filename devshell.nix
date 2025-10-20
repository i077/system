{
  pkgs,
  perSystem,
  ...
}:
perSystem.devshell.mkShell {
  name = "system";
  packages = with pkgs; [
    # Wrap nix to support flakes
    (writeShellScriptBin "nix" ''
      ${lib.getExe nixVersions.latest} --extra-experimental-features "nix-command flakes" "$@"
    '')
    cachix
    jo
    nvd
    perSystem.self.formatter
  ];

  commands = [
    {package = pkgs.just;}
  ];
}
