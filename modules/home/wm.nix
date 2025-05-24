{...}: let
  mod = "ctrl-cmd-alt";
in {
  programs.aerospace = {
    enable = true;
    userSettings = {
      start-at-login = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      gaps = {
        inner.horizontal = 4;
        inner.vertical = 4;
        outer.left = 4;
        outer.right = 4;
        outer.top = 4;
        outer.bottom = 4;
      };

      mode.main.binding = {
        # Focus
        "${mod}-h" = "focus left";
        "${mod}-j" = "focus down";
        "${mod}-k" = "focus up";
        "${mod}-l" = "focus right";

        # Move
        "${mod}-shift-h" = "move left";
        "${mod}-shift-j" = "move down";
        "${mod}-shift-k" = "move up";
        "${mod}-shift-l" = "move right";

        # Resize
        "${mod}-minus" = "resize smart -50";
        "${mod}-equal" = "resize smart +50";
        "${mod}-shift-minus" = "resize smart-opposite -50";
        "${mod}-shift-equal" = "resize smart-opposite +50";
        "${mod}-enter" = "fullscreen";

        # Layout mode
        "${mod}-slash" = "layout tiles horizontal vertical";
        "${mod}-comma" = "layout accordion horizontal vertical";

        # Workspaces
        "${mod}-1" = "workspace 1";
        "${mod}-2" = "workspace 2";
        "${mod}-3" = "workspace 3";
        "${mod}-4" = "workspace 4";
        "${mod}-5" = "workspace 5";
        "${mod}-6" = "workspace 6";
        "${mod}-7" = "workspace 7";
        "${mod}-8" = "workspace 8";
        "${mod}-9" = "workspace 9";
        "${mod}-0" = "workspace 10";
        "${mod}-shift-1" = "move-node-to-workspace 1";
        "${mod}-shift-2" = "move-node-to-workspace 2";
        "${mod}-shift-3" = "move-node-to-workspace 3";
        "${mod}-shift-4" = "move-node-to-workspace 4";
        "${mod}-shift-5" = "move-node-to-workspace 5";
        "${mod}-shift-6" = "move-node-to-workspace 6";
        "${mod}-shift-7" = "move-node-to-workspace 7";
        "${mod}-shift-8" = "move-node-to-workspace 8";
        "${mod}-shift-9" = "move-node-to-workspace 9";
        "${mod}-shift-0" = "move-node-to-workspace 10";

        "${mod}-r" = "mode resize";
      };

      mode.resize.binding = {
        h = "resize width -50";
        j = "resize height +50";
        k = "resize height -50";
        l = "resize width +50";
        esc = "mode main";
      };
    };
  };
}
