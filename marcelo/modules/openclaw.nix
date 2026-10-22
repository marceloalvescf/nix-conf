{
  inputs,
  pkgs,
  ...
}:

let
  openclaw = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.openclaw;
  port = "18789";
in
{
  home.packages = [ openclaw ];

  # Mirrors the unit `openclaw gateway install` would write, declared here so
  # it tracks the store path. The unit name and OPENCLAW_* service markers let
  # `openclaw gateway status/restart` recognise and drive this service.
  systemd.user.services.openclaw-gateway = {
    Unit = {
      Description = "OpenClaw Gateway";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
      StartLimitBurst = 10;
      StartLimitIntervalSec = 300;
    };
    Service = {
      # Traefik reaches the gateway over the Docker bridge, so it cannot stay on
      # loopback. The host firewall only trusts Docker interfaces, keeping the
      # port closed to the LAN; openclaw-sc.alvesm.dev is the way in.
      ExecStart = "${openclaw}/bin/openclaw gateway --port ${port} --bind lan";
      # SIGUSR1 triggers the gateway's in-process restart.
      ExecReload = "${pkgs.coreutils}/bin/kill -USR1 $MAINPID";
      WorkingDirectory = "%h/.openclaw";
      Environment = [
        "OPENCLAW_STATE_DIR=%h/.openclaw"
        "OPENCLAW_GATEWAY_PORT=${port}"
        "OPENCLAW_SYSTEMD_UNIT=openclaw-gateway.service"
        "OPENCLAW_SERVICE_MARKER=openclaw"
        "OPENCLAW_SERVICE_KIND=gateway"
        # Agent tool calls need the user's packages, not systemd's bare PATH.
        "PATH=/etc/profiles/per-user/%u/bin:/run/current-system/sw/bin"
      ];
      Restart = "always";
      RestartSec = 5;
      # 78 = config error (don't loop); 143 = clean SIGTERM shutdown.
      RestartPreventExitStatus = 78;
      SuccessExitStatus = "0 143";
      # Upstream's shutdown budget is 325 s; leave it room to drain.
      TimeoutStopSec = 330;
      TimeoutStartSec = 30;
      OOMPolicy = "continue";
      KillMode = "mixed";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
