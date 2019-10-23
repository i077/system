{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "paperwm-${version}";
  version = "2019-10-23";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "e75f3aac7f46fb6c019647853ca9c0d6906d0789";
    sha256 = "1400fkpkq9cl9r18258q21m1vfvjclpqz0rx12736ysqzvj0fwbb";
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
