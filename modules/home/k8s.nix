# Kubneretes-related tooling
{pkgs, ...}: {
  home.packages = with pkgs; [kubectl kubectl-node-shell kubectx kubernetes-helm fluxcd stern vcluster];

  # Add kubectl & friends as aliases
  programs.fish.shellAbbrs = {
    k = "kubectl";
    kcx = "kubectx";
    kns = "kubens";
  };

  # k9s at work
  programs.k9s.enable = true;
}
