{
  pkgs,
  inputs,
  ...
}:

let
  # Import packages from flake root
  claude-desktop = pkgs.callPackage (inputs.self + "/pkgs/claude-desktop/pkg.nix") { };
  lens = import (inputs.self + "/pkgs/lens-desktop/pkg.nix") { inherit pkgs; };
  spotify-xwayland = import (inputs.self + "/pkgs/spotify-xwayland/pkg.nix") { inherit pkgs; };
  attack-shark-x11 = pkgs.callPackage (inputs.self + "/pkgs/attack-shark-x11/pkg.nix") { };
  chatgpt = pkgs.callPackage (inputs.self + "/pkgs/chatgpt/pkg.nix") { };
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
    GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
  };

  imports = [
    ./modules/bash.nix
    ./modules/chromium.nix
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/gnome.nix
    ./modules/gtk.nix
    ./modules/kubernetes.nix
    ./modules/neovim.nix
    ./modules/obs-studio.nix
    ./modules/packages.nix
    ./modules/ptyxis.nix
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
    spotify-xwayland
    chatgpt
  ];

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
