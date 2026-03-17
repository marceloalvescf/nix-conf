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
}
