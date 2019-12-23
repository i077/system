{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "bobthefish";
  version = "2019-11-02";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "theme-bobthefish";
    rev = "f3301c2e2c1a5664634ccd0181289cc4037a0411";
    sha256 = "1b4vrl2rhj4ypjjhbvgx5kzkhn423fqgb4jl0ckjvg1z5xlc874k";
  };

  installPhase = ''
    mkdir -p $out/lib
    cp -r . $out/lib/bobthefish
  '';
}
