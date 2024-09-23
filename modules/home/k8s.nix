# Kubneretes-related tooling
{pkgs, ...}: {
  home.packages = with pkgs; [kubectl kubectx kubernetes-helm eksctl fluxcd stern vcluster];

  # Add kubectl & friends as aliases
  programs.fish.shellAbbrs = {
    k = "kubectl";
    kcx = "kubectx";
    kns = "kubens";
  };

  # k9s at work
  programs.k9s.enable = true;
}
