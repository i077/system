{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "paperwm-${version}";
  version = "2019-06-27-86beb27";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "86beb27e04045ce38e4a0da7267ef600a2cfdcfc";
    sha256 = "0daqh8qw1g1i3icf9p01f5x4ga6wqvlvyk3h6spvwpfxj4aagfsx";
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
