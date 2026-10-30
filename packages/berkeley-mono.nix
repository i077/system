{
  pkgs,
  pname,
  ...
}: let
  inherit (pkgs) lib;
in
  pkgs.stdenvNoCC.mkDerivation {
    inherit pname;
    version = "2.004";

    src = pkgs.requireFile rec {
      name = "${pname}-typeface.zip";
      hash = "sha256-57uBDP2icHA7B9JEQe+YJd1+mHutxYYRs/W6t4Ezgyk=";

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
  }
