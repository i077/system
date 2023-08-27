{
  config,
  lib,
  ...
}: {
  # Add remote builders
  nix.distributedBuilds = true;
  nix.buildMachines = lib.optional (config.networking.hostName != "combee") {
    hostName = "combee";
    sshUser = "nixremote";
    publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUcwczlkNTdWY1ZpcjZJa2srZktwbjh1WXVHcGMveS9yak9DRzRYZFg5aHQgcm9vdEBuaXhvcwo=";
    protocol = "ssh-ng";
    systems = ["x86_64-linux" "aarch64-linux"];
    maxJobs = 4;
    supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
  };
}
