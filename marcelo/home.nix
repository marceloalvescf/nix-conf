{
  pkgs,
  inputs,
  ...
}:

let
  # Import packages from flake root
  lens = import (inputs.self + "/pkgs/lens-desktop/pkg.nix") { inherit pkgs; };
in
{
  home.username = "marcelo";
  home.homeDirectory = "/home/marcelo";
  home.stateVersion = "25.05";
  home.sessionVariables = {
    ANSIBLE_SSH_ARGS = "-o ControlMaster=no";
    EDITOR = "nvim";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    TG_DOWNLOAD_DIR = "$HOME/.terragrunt-cache";
  };
  home.sessionPath = [ "$HOME/.local/bin" ];
  # hm-session-vars.sh only reaches login shells; desktop-launched apps inherit
  # the systemd user environment. NixOS sets an absolute PATH in
  # /etc/environment.d/50-systemd-path.conf, so prepend from a later file.
  xdg.configFile."environment.d/60-local-bin.conf".text = ''
    PATH=$HOME/.local/bin:$PATH
  '';

  imports = [
    ./modules/bash.nix
    ./modules/chromium.nix
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/gpg.nix
    ./modules/kitty.nix
    ./modules/kubernetes.nix
    ./modules/mimeapps.nix
    ./modules/neovim.nix
    ./modules/obs-studio.nix
    ./modules/openclaw.nix
    ./modules/packages.nix
    ./modules/plasma.nix
    ./modules/secrets.nix
    ./modules/ssh.nix
    ./modules/starship.nix
    ./modules/tmux.nix
    ./modules/vscode.nix
    ./modules/zeditor.nix
  ];

  home.packages = [
    lens
  ];

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
