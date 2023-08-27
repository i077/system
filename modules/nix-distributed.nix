{
  # Add remote builders
  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "eu.nixbuild.net";
      systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 100;
      supportedFeatures = ["benchmark" "big-parallel"];
    }
  ];
}
