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

    # kind's node image ships /usr/lib/sysctl.d/10-coredump-debian.conf with
    # kernel.core_pattern=core. Its privileged systemd applies that against the
    # host's non-namespaced sysctl, so dumps bypass systemd-coredump and land as
    # ./core.<pid> in each crashing process' cwd. Re-assert the pipe handler.
    services.restore-core-pattern = {
      description = "Restore kernel.core_pattern clobbered by privileged containers";
      after = [ "docker.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${config.systemd.package}/lib/systemd/systemd-sysctl --prefix=/proc/sys/kernel/core_pattern";
      };
    };

    timers.restore-core-pattern = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "30s";
        OnUnitActiveSec = "5min";
      };
    };

    # Belt for the window before the timer fires: RLIMIT_CORE=0 blocks
    # kernel-written core files, but is ignored on the systemd-coredump pipe.
    settings.Manager.DefaultLimitCORE = "0";
    user.settings.Manager.DefaultLimitCORE = "0";
  };
}
