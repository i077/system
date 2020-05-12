{ ... }:

{
  home-manager.users.imran.services.random-background = {
    enable = true;
    imageDirectory = "%h/Pictures/walls";
    interval = "6h";
  };
}
