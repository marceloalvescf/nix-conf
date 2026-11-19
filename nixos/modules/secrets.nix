{ ... }:

{
  # Point to your secrets file
  sops = {
    defaultSopsFile = ../../secrets/marcelo.yaml;
    defaultSopsFormat = "yaml";

    # Age key location
    age = {
      keyFile = "/home/marcelo/.config/sops/age/keys.txt";
      generateKey = false; # We're using existing SSH-derived key
    };

    # Each value is a complete KEY=value line, consumed as a container env file
    secrets = {
      cloudflare_api_token = { };
      grafana_admin_password = { };
    };
  };
}
