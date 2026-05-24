{ ... }:

{
  # Made /etc/hosts file writable
  environment.etc.hosts.mode = "0755";

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Locale related settings
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
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
      # extraConfig = ''
      #   # Limit individual dump to 500MB (enough for most debugging)
      #   ProcessSizeMax=500M
      #   ExternalSizeMax=500M

      #   # Keep only 1GB total of dumps
      #   MaxUse=1G

      #   # Compress dumps to save space
      #   Compress=yes
      # '';
    };
  };
}
