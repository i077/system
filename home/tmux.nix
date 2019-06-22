{ config, pkgs, ...}:

{
  programs.tmux = {
    enable = true;

    # Set prefix to C-a
    shortcut = "a";

    # Resize to smallest session
    aggressiveResize = true;

    clock24 = true;

    # Use vi bindings
    keyMode = "vi";

    # Rest of .tmux.conf
    extraConfig = ''
      # Mouse
      set-option -g mouse on

      # Disable escape timeout
      set -s escape-time 0

      # Window switching
      bind-key C-h select-pane -L
      bind-key C-j select-pane -D
      bind-key C-k select-pane -U
      bind-key C-l select-pane -R
    '';
  };
}
