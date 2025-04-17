{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      # The pkgs set used to instantiate the berkeley-mono package must have allowUnfree set
      # so others can use it.
      config.allowUnfree = true;
    };

    packages.berkeley-mono = let
      inherit (pkgs) lib;
      pname = "berkeley-mono";
    in
      pkgs.stdenvNoCC.mkDerivation {
        inherit pname;
        version = "2.000";

        src = pkgs.requireFile rec {
          name = "${pname}-typeface.zip";
          sha256 = "0iakm2ga73k1ia81zg20ws1dk2ssmdb257aqx7nbq0pkv1nxdr1c";

          message = ''
            Log in to https://usgraphics.com/auth/login/, and
            download the Berkeley Mono typeface with:
            - TrueType format
            - Normal width
            - All widths
            - All slants
            - Glyph alternatives: dotted zero, standard seven
            - No contextual alternatives

            Zip up all .ttf files and add the zip to the Nix store with:
            $ nix store add-file /path/to/${name}
          '';
        };
        sourceRoot = ".";

        nativeBuildInputs = with pkgs; [unzip parallel];

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
          homepage = "https://usgraphics.com/products/berkeley-mono";
          license = lib.licenses.unfree;
          maintainers = [lib.maintainers.i077];
          platforms = lib.platforms.all;
        };
      };
  };
}
