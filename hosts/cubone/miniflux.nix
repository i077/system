{...}: {
  services.miniflux = {
    enable = true;
    adminCredentialsFile = "/etc/miniflux-creds.conf";
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
