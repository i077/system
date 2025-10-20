# Kubneretes-related tooling
{
  perSystem,
  pkgs,
  ...
}: let
  kubesess = perSystem.nix-hot-pot.kubesess.overrideAttrs (old: {
    postInstall = ''
      mkdir -p $out/share/fish/vendor_completions.d $out/share/fish/vendor_functions.d
      cp scripts/fish/completions/*.fish $out/share/fish/vendor_completions.d
      cp scripts/fish/functions/*.fish $out/share/fish/vendor_functions.d
    '';
  });
in {
  home.packages = with pkgs; [kubectl kubectl-node-shell kubernetes-helm kubesess fluxcd stern vcluster];

  # Add kubectl & friends as aliases
  programs.fish = {
    shellAbbrs = {
      k = "kubectl";
    };
  };

  programs.k9s.enable = true;
}
