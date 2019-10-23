{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-switcher-${version}";
  version = "unstable-2019-04-21";

  src = fetchFromGitHub {
    owner = "daniellandau";
    repo = "switcher";
    rev = "587dbb0f2682a8858f4f5c2996f4730b673bfd49";
    sha256 = "0mqbcdm7115pnxy4ngr9y0ip783813ihima1svnvr0zb3g6qlpgq";
  };

  uuid = "switcher@landau.fi";
  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = "Gnome Shell extension to switch windows quickly by typing ";
    homepage = https://github.com/daniellandau/switcher;
    license = licenses.gpl3;
  };
}
