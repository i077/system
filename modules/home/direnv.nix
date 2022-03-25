{ ... }: {
  programs.direnv = {
    enable = true;
    nix-direnv = { enable = true; };

    stdlib = ''
      # Store .direnv in cache instead of project dir
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
              echo -n ~/.cache/direnv/layouts/
              echo -n "$PWD" | sha256sum | cut -d ' ' -f 1
          )}"
      }
    '';
  };
}
