# roles/personal/xdg.nix -- Move everything into XDG directories to keep ~ as neat as possible

{ ... }:

{
  hm.xdg.enable = true;

  # Set XDG dirs as early as possible
  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";
  };
  environment.variables = {
    # NVIDIA/CUDA
    __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";

    # less
    LESSHISTFILE = "$XDG_DATA_HOME/lesshst";
  };
}
