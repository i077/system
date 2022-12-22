{...}: let
  listenPort = 8080; in {
  services.miniflux = {
    enable = true;
    config = {
      PORT = toString listenPort;
    };
    adminCredentialsFile = "/etc/miniflux-creds.conf";
  };

  networking.firewall.allowedTCPPorts = [ listenPort ];
}
