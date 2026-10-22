{
  inputs,
  lib,
  ...
}: let
  l = inputs.omniwm.lib;
  mkNumHotkeys = command: binding:
    lib.genAttrs'
    (lib.range 1 9)
    (n: lib.nameValuePair (command + "." + (toString (n - 1))) (binding + "+" + (toString n)));
in {
  programs.omniwm = {
    enable = true;
    preserveSettings = ["monitors" "routing"];

    settings = {
      general = {
        defaultLayoutType = "niri";
        hyperKeyModifiers = "Control+Option+Command";
        animationSpeed = 1;
        animationsEnabled = true;
      };

      borders = {
        enabled = true;
        width = 3;
        color = l.colors.fromHex "#007A02";
      };

      niri = {
        alwaysCenterSingleColumn = true;
        containerPrimarySpanPresets = [0.33 0.5 0.67];
      };

      overview.enabled = true;

      workspaces = l.workspaces [
        {}
        {}
        {}
        {}
        {}
        {}
        {}
        {monitorAssignment.type = "secondary";}
        {monitorAssignment.type = "secondary";}
      ];

      workspaceBar = {
        enabled = true;
        height = 28;
        position = "belowMenuBar";
        notchMode = "moveBelowMenuBar";
        revealModifier = "controlOptionCommand";
        inactiveIconOpacity = 0.3;
      };

      mouseWarp.enabled = true;

      hotkeys = l.hotkeys (
        {
          # Focus & movement
          "focusDownOrLeft" = "Hyper+Comma";
          "focusUpOrRight" = "Hyper+Period";
          "moveColumn.left" = "Hyper+Shift+Comma";
          "moveColumn.right" = "Hyper+Shift+Period";
          "centerColumn" = "Hyper+C";
          "consumeWindowIntoColumn" = "Hyper+I";
          "expelWindowFromColumn" = "Hyper+O";
          "focusColumnFirst" = "Hyper+Home";
          "focusColumnLast" = "Hyper+End";

          "toggleColumnTabbed" = "Hyper+T";

          "toggleOverview" = "Hyper+Grave";

          # Resizing
          "cycleSizeForward" = "Hyper+R";
          "cycleWindowSecondarySpanForward" = "Hyper+Shift+R";
          "setContainerPrimarySpan.decrease10Percent" = "Hyper+Minus";
          "setContainerPrimarySpan.increase10Percent" = "Hyper+Equal";
          "toggleContainerFullPrimarySpan" = "Hyper+F";
        }
        // (mkNumHotkeys "switchWorkspace" "Hyper")
        // (mkNumHotkeys "moveToWorkspace" "Hyper+Shift")
      );

      quakeTerminal.enabled = false;
    };
  };
}
