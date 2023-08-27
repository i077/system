{
  config,
  lib,
  ...
}: {
  # Add remote builders
  nix.distributedBuilds = true;
  nix.buildMachines = lib.optional (config.networking.hostName != "combee") {
    hostName = "combee";
    systems = ["x86_64-linux" "aarch64-linux"];
    maxJobs = 4;
    supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
  };
}
