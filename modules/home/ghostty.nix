{lib, ...}: let
  mkCfg = lib.generators.toKeyValue {listsAsDuplicateKeys = true;};
in {
  xdg.configFile."ghostty/config".text = mkCfg {
    font-family = "Berkeley Mono";
    font-size = 14;
    font-thicken = true;

    theme = "GruvboxDark";
    mouse-hide-while-typing = true;

    cursor-style-blink = false;
  };
}
