{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "paperwm-${version}";
  version = "2019-11-20";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "b58050f7f5915634fe67faeec1dfa113f6df7d1c";
    sha256 = "1l8y79fdhp2d8pha73yaf385ag49hx1lvajq154fqx84ha361mpj";
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
