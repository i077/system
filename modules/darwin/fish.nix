{lib, ...}: let
  inherit (lib) mkAfter mkBefore mkMerge;
in {
  programs.fish.enable = true;
  # Workaround for $PATH ordering in fish
  # /usr/libexec/path_helper prepends system paths before anything else
  environment.etc."fish/nixos-env-preinit.fish".text = mkMerge [
    (mkBefore ''
      set -l oldPath $PATH
    '')
    (mkAfter ''
      for elt in $PATH
        if not contains -- $elt $oldPath /usr/local/bin /usr/bin /bin /usr/sbin /sbin
          set -ag fish_user_paths $elt
        end
      end
      set -el oldPath
    '')
  ];
}
