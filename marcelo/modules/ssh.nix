{ ... }:

{
  # YubiKey OpenPGP authentication key; gpg-agent serves the private half
  home.file.".ssh/yubikey.pub".text = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP06mYP7ylaM3tb0r5ADMclMrKrpwPjfHvjO81Nqoc+E cardno:22_829_076
  '';

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        userKnownHostsFile = "~/.ssh/known_hosts";
        identitiesOnly = true;
        identityFile = "~/.ssh/yubikey.pub";
      };
      "openwrt-r4s" = {
        user = "root";
        hostname = "192.168.100.1";
      };
    };
  };
}
