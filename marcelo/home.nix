{
  pkgs,
  inputs,
  ...
}:

let
  # Import packages from flake root
  claude-desktop = pkgs.callPackage (inputs.self + "/pkgs/claude-desktop/pkg.nix") { };
  lens = import (inputs.self + "/pkgs/lens-desktop/pkg.nix") { inherit pkgs; };
  attack-shark-x11 = pkgs.callPackage (inputs.self + "/pkgs/attack-shark-x11/pkg.nix") { };
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

  imports = [
    ./modules/bash.nix
    ./modules/chromium.nix
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/gtk.nix
    ./modules/kitty.nix
    ./modules/kubernetes.nix
    ./modules/neovim.nix
    ./modules/obs-studio.nix
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
    attack-shark-x11
    claude-desktop
    lens
  ];

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
