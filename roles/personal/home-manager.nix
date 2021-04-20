{ inputs, lib, ... }:

let inherit (lib.mine.files) mapFilesRecToList;
in {
  # Home-manager
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  hm.home.stateVersion = "20.09";
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };
  hm.programs.home-manager.enable = true;

  # Import custom home-manager modules
  hm.imports = mapFilesRecToList import ../../hm-modules;

  # Autostart user systemd services
  hm.systemd.user.startServices = true;
}
