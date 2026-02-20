{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    kind
    kubectl
    kubectx
    kubernetes-helm
    minikube
    velero
  ];
}
