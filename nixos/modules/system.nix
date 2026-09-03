{ config, ... }:

{
  # Made /etc/hosts file writable
  environment.etc.hosts.mode = "0755";

  # Set your time zone.
  time.timeZone = "Etc/GMT+3";

  # Locale related settings
  i18n = {
    defaultLocale = "C.UTF-8";
    inputMethod = {
      enable = true;
      type = "ibus";
    };
  };

  # Configure console keymap
  console.keyMap = "us";

  systemd = {
    coredump = {
      settings = {
        Coredump = {
          # Limit individual dump to 500MB (enough for most debugging)
          ProcessSizeMax = "500M";
          ExternalSizeMax = "500M";

          # Keep only 1GB total of dumps
          MaxUse = "1G";

          # Compress dumps to save space
          Compress = "yes";
        };
      };
    };
  };
}
