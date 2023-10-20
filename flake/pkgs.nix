{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs-darwin {
      inherit system;
      # The pkgs set used to instantiate the berkeley-mono package must have allowUnfree set
      # so others can use it.
      config.allowUnfree = true;
    };

    packages.berkeley-mono = let
      inherit (pkgs) lib;
      pname = "berkeley-mono";
    in
      pkgs.stdenv.mkDerivation {
        inherit pname;
        version = "1.009";

        src = pkgs.requireFile rec {
          name = "${pname}-typeface.zip";
          hash = "sha256-aMmQSuLzAt+Z92QvjpYGVIICpDaHc+DDSwhRt0l2XNQ=";

          message = ''
            Log in to https://berkeleygraphics.com/accounts/login/,
            download the Berkeley Mono typeface, and add it to the Nix store with:

            $ nix store add-file /path/to/${name}
          '';
        };
        sourceRoot = ".";

        nativeBuildInputs = with pkgs; [unzip];

        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          runHook preInstall

          installDir=$out/share/fonts/truetype
          mkdir -p $installDir
          find . -name "*.ttf" -exec cp -a {} $installDir \;

          runHook postInstall
        '';

        meta = {
          homepage = "https://berkeleygraphics.com/typefaces/berkeley-mono/";
          license = lib.licenses.unfree;
          maintainers = [lib.maintainers.i077];
          platforms = lib.platforms.all;
        };
      };
  };
}
