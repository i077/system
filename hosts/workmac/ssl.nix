{
  config,
  lib,
  pkgs,
  ...
}: {
  # Add Private CA
  security.pki.certificateFiles = lib.optional config.lib.env.isCi [
    (pkgs.requireFile {
      name = "private-ca.cer";
      hash = "sha256-VNdLlz0lEC7cQhEr+DXAHqkWWpPKtZDUjgI8vSSSmPU=";

      message = ''
        Export the private root CA's certificate from Keychain Access, and add with
        $ nix store add-file /path/to/private-ca.cer
      '';
    })
  ];

  # Configure various CLIs to use the built CA bundle
  home-manager.users.hossaini.home.sessionVariables = builtins.listToAttrs (map
    (var: {
      name = var;
      value = "/etc/ssl/certs/ca-certificates.crt";
    })
    ["AWS_CA_BUNDLE" "CURL_CA_BUNDLE" "REQUESTS_CA_BUNDLE"]);
}
