{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "paperwm-${version}";
  version = "2019-10-23";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "0bd9de889e29c9fcc7de5f4348975c36efd7c8f8";
    sha256 = "1g3ml9gp2ihfg14k14djbrn2bhgjrcp1r2ka3g0cp34p9j3nkk08";
  };

  uuid = "paperwm@hedning:matrix.org";

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = "Tiled scrollable window management for Gnome Shell";
    license = licenses.gpl3;
    homepage = https://github.com/paperwm/PaperWM;
  };
}
