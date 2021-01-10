{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3 }:

let
  pname = "everdo";
  version = "1.5.3";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://d11l8siwmn8w36.cloudfront.net/1.5.3/Everdo-1.5.3.AppImage";
    sha256 = "03rlr7krys7hmdn19wvda21if4l8n4vn95hx7n1vcffp9s33zkna";
  };

  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [ p.at-spi2-atk p.at-spi2-core ];
  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/everdo.desktop $out/share/applications/everdo.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/everdo.png \
      $out/share/icons/hicolor/1024x1024/apps/everdo.png
    substituteInPlace $out/share/applications/everdo.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Todo list and Getting Things Done app";
    homepage = "https://everdo.net";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ i077 ];
  };
}
