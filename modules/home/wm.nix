{
  services.paneru = {
    enable = true;

    # See https://github.com/karinushka/paneru/blob/main/CONFIGURATION.md
    settings = {
      options = {
        animation_speed = 12;
        focus_follows_mouse = true;
        mouse_follows_focus = true;
        preset_column_widths = [
          0.33
          0.5
          0.66
          0.8
        ];
        horizontal_mouse_warp = -1;
      };

      padding = {
        left = 4;
        right = 4;
      };

      swipe.gesture.fingers_count = 3;

      decorations.inactive.dim = {
        opacity = -0.1;
        opacity_night = -0.1;
      };

      bindings = {
        window_focus_west = "alt-h";
        window_focus_east = "alt-l";
        window_focus_north = "alt-k";
        window_focus_south = "alt-j";

        window_swap_west = "alt+shift-h";
        window_swap_east = "alt+shift-l";
        window_swap_north = "alt+shift-k";
        window_swap_south = "alt+shift-j";

        window_virtual_north = "alt-m";
        window_virtual_south = "alt-n";
        window_virtualmove_north = "alt+shift-m";
        window_virtualmove_south = "alt+shift-n";
        window_nextdisplay = "alt+shift-]";

        window_stack = "alt-i";
        window_unstack = "alt-o";

        window_center = "alt-c";

        window_manage = "alt-f";

        window_resize = "alt-r";
        window_fullwidth = "alt-return";
      };

      windows.antinote = {
        title = ".*";
        bundleID = "com.chabomakers.Antinote";
        floating = true;
      };
    };
  };
}
