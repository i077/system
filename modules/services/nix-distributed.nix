{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.services.nix-distributed;
in {
  options.modules.services.nix-distributed = { enable = mkEnableOption "distributed nix builds"; };

  config = mkIf cfg.enable {
    # Declare ssh privkey secret
    sops.secrets.builder-sshkey = { };

    nix = {
      distributedBuilds = true;

      # Add builders
      buildMachines = [{
        hostName = "machamp";
        system = "x86_64-linux";
        maxJobs = 8;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        speedFactor = 2;
        sshKey = config.sops.secrets.builder-sshkey.path;
      }];

      # Let builders use their own substituters
      extraOptions = ''
        builders-use-substitutes = true
      '';
    };

    programs.ssh = {
      knownHosts = {
        machamp = {
          hostNames = [ "[jasonpax.tech]:6492" ];
          publicKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIcOmNqzKw2E0/u24lA+StBs+znRYKSTIdv6QB037uVS";
        };

      };
      extraConfig = ''
        Host machamp
            HostName jasonpax.tech
            User root
            Port 6492
      '';
    };
  };
}
