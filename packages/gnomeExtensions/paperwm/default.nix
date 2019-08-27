{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "paperwm-${version}";
  version = "2019-07-24";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "611680e06be5ef4f1e9aa1da85de6b83ee5fba31";
    sha256 = "0ql3zd66b83kzyidsr6rpfqincyljgb9j8k0p0c58s6fgsvwzhc4";
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
