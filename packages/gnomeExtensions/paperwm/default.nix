{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "paperwm-${version}";
  version = "2019-08-24";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "95b6cd673d77f489610892bff2cf018127da35cf";
    sha256 = "0h7q561laika4a6hz77lq3wcrxjs2c6qz40xzdajry0x1dp3776m";
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
