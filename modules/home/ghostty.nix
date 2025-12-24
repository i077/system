{lib, ...}: let
  mkCfg = lib.generators.toKeyValue {listsAsDuplicateKeys = true;};
in {
  xdg.configFile."ghostty/config".text = mkCfg {
    font-family = "Berkeley Mono";
    font-size = 14;
    font-thicken = true;

    theme = "dark:Monokai Pro Ristretto,light:Monokai Pro Light Sun";
    mouse-hide-while-typing = true;

    macos-option-as-alt = "left";

    cursor-style-blink = false;
  };
}
