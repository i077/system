{
  services.paneru = {
    enable = true;

    settings = {
      options = {
        animation_speed = 12;
        focus_follows_mouse = true;
        mouse_follows_focus = true;
        preset_column_widths = [0.33 0.5 0.66 0.8];
      };

      padding = {
        left = 4;
        right = 4;
      };

      swipe.gesture.fingers_count = 3;

      decorations.inactive.dim = {
        opacity = -0.2;
        opacity_night = -0.3;
      };

      bindings = {
        window_focus_west = "ctrl+alt-h";
        window_focus_east = "ctrl+alt-l";
        window_focus_north = "ctrl+alt-k";
        window_focus_south = "ctrl+alt-j";

        window_swap_west = "ctrl+alt+shift-h";
        window_swap_east = "ctrl+alt+shift-l";
        window_swap_north = "ctrl+alt+shift-k";
        window_swap_south = "ctrl+alt+shift-j";

        window_stack = "ctrl+alt-i";
        window_unstack = "ctrl+alt-o";

        window_center = "ctrl+alt-c";

        window_manage = "ctrl+alt-f";

        window_resize = "ctrl+alt-r";
        window_fullwidth = "ctrl+alt-return";
      };
    };
  };
}
