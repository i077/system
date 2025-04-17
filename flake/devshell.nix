# This part defines the development environment experience as built by `nix develop`.
{inputs, ...}: {
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.devshell.flakeModule
  ];

  perSystem = {
    config,
    inputs',
    pkgs,
    ...
  }: {
    devshells.default = {
      name = "system";
      packages = with pkgs; [
        # Wrap nix to support flakes
        (writeShellScriptBin "nix" ''
          ${lib.getExe nixVersions.latest} --extra-experimental-features "nix-command flakes" "$@"
        '')
        cachix
        jo
        nvd
      ];

      commands = [
        {package = pkgs.just;}
        {package = config.treefmt.build.wrapper;}
      ];
    };

    treefmt = {
      projectRootFile = ".git/config";
      programs.alejandra.enable = true;
      programs.prettier.enable = true;
      programs.stylua.enable = true;
      settings.formatter.fish = {
        command = "${pkgs.fish}/bin/fish_indent";
        options = ["--write"];
        includes =
          ["*.fish"]
          ++
          # Exclude non-fish scripts in ./bin from formatter
          (pkgs.lib.pipe ../bin [
            builtins.readDir # Read the ./bin directory
            (pkgs.lib.flip builtins.removeAttrs ["imgcat"]) # Remove non-fish scripts
            builtins.attrNames # Just get the names of the files
            (map (x: "bin/${x}")) # Map names to their actual paths relative to repo's root
          ]);
      };
      settings.formatter.just = {
        command = pkgs.lib.getExe pkgs.just;
        options = ["--fmt" "--unstable" "-f"];
        includes = ["Justfile"];
      };
    };
  };
}
