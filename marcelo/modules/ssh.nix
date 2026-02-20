{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        userKnownHostsFile = "~/.ssh/known_hosts";
        identitiesOnly = true;
      };
      "openwrt-r4s" = {
        user = "root";
        hostname = "192.168.100.1";
        identityFile = "~/.ssh/id_ed25519";
      };
      "ubuntu-work" = {
        user = "marcelo";
        hostname = "192.168.122.100";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
