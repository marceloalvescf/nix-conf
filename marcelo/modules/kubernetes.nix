{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    cloud-provider-kind
    kind
    kubectl
    kubectx
    kubernetes-helm
    minikube
    velero
  ];

  systemd.user.services.cloud-provider-kind = {
    Unit = {
      Description = "Cloud provider for kind clusters (LoadBalancer support)";
      After = "docker.service";
    };

    Service = {
      ExecStart = "${pkgs.cloud-provider-kind}/bin/cloud-provider-kind --gateway-channel disabled";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
