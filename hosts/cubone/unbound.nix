{ config, lib, pkgs, ... }: {
  services.unbound = {
    enable = true;
    settings = {
      server = {
        verbosity = "0";
        port = "5353";

        do-ip4 = "yes";
        do-ip6 = "yes";
        do-udp = "yes";
        do-tcp = "yes";

        root-hints = "${config.services.unbound.stateDir}/named.root";

        harden-glue = "yes";
        harden-dnssec-stripped = "yes";
        use-caps-for-id = "no";
        edns-buffer-size = "1472";

        prefetch = "yes";

        num-threads = "1";

        private-address = [
          "192.168.0.0/16"
          "172.16.0.0/12"
          "fd00::/8"
          "fe80::/10"
          # Tailscale subnets
          "100.16.0.0/10"
          "fd7a:115c:a1e0::/48"
        ];
      };
    };
  };

  # root-hints have to be downloaded without DNS being available
  networking.hosts = { "192.0.47.9" = [ "internic.net" "www.internic.net" ]; };

  systemd.services.unbound.preStart = ''
    set -euo pipefail
    # Update DNSSEC root anchor
    ${
      lib.getExe pkgs.unbound
    } -a ${config.services.unbound.stateDir}/root.key || echo "Root anchor updated!"
    # Download root hints
    ${
      lib.getExe pkgs.curl
    } -fsSL -o ${config.services.unbound.stateDir}/named.root https://www.internic.net/domain/named.root
  '';

  networking.resolvconf.useLocalResolver = false;
}
