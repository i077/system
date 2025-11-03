{lib, ...}: let
  mkCfg = lib.generators.toKeyValue {listsAsDuplicateKeys = true;};
in {
  xdg.configFile."ghostty/config".text = mkCfg {
    font-family = "Berkeley Mono";
    font-size = 14;
    font-thicken = true;

    theme = "Monokai Pro Spectrum";
    mouse-hide-while-typing = true;

    macos-option-as-alt = "left";

    cursor-style-blink = false;
  };
}
