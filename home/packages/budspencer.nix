{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "budspencer";
  version = "2019-01-06";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "theme-budspencer";
    rev = "6e82b28c7322408ecafca115321f819c16b6d2fb";
    sha256 = "0dkv8wffk9d10l46j4pdq29b4a431v5p8w96nb9kad38bn695q3f";
  };

  installPhase = ''
    mkdir -p $out/lib
    cp -r . $out/lib/budspencer
  '';
}
