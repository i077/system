{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-timepp-${version}";
  version = "unstable-2019-06-14";

  src = fetchFromGitHub {
    owner = "zagortenay333";
    repo = "timepp__gnome";
    rev = "3be06b0677bdfe6f220a61f4b26f411762d20f30";
    sha256 = "18h9gz52fmd6sgnyyi8k1fkg0yzhmx98cgp99q054amn78asc0xk";
  };

  uuid = "timepp@zagortenay333";
  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = "A todo.txt manager, time tracker, timer, stopwatch, pomodoro, and alarms gnome-shell extension.";
    homepage = https://github.com/zagortenay333/timepp__gnome;
    license = licenses.gpl3;
  };
}
