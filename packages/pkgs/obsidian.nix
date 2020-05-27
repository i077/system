{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3 }:

let
  pname = "obsidian";
  version = "0.6.4";

  name = "${pname}-${version}";

  # Fetch from my keybase public directory
  src = fetchurl {
    url = "https://i077.keybase.pub/Obsidian-${version}.AppImage";
    sha256 = "14yawv9k1j4lly9c5hricvzn9inzx23q38vsymgwwy6qhkpkrjcb";
  };

  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = p:
    (appimageTools.defaultFhsEnvArgs.multiPkgs p)
    ++ [ p.at-spi2-atk p.at-spi2-core ];
  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/obsidian.desktop $out/share/applications/obsidian.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/obsidian.png \
      $out/share/icons/hicolor/512x512/apps/obsidian.png
    substituteInPlace $out/share/applications/obsidian.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A second brain for you, forever";
    homepage = "https://obsidia.md";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ i077 ];
  };
}
