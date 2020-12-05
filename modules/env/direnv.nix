{ ... }:

{
  home-manager.users.imran.programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    enableNixDirenvIntegration = true;
  };
}
