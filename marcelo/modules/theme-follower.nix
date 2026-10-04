{ config, pkgs, ... }:

let
  dconf = "${pkgs.dconf}/bin/dconf";
  interface = "/org/gnome/desktop/interface";
  ptyxisProfile = "/org/gnome/Ptyxis/Profiles/${
    config.dconf.settings."org/gnome/Ptyxis".default-profile-uuid
  }";

  apply = pkgs.writeShellScript "gnome-theme-apply" ''
    if [ "$(${dconf} read ${interface}/color-scheme)" = "'prefer-dark'" ]; then
      gtk=Qogir-Dark icons=Qogir-Dark cursor=Qogir-Dark palette="Catppuccin Mocha"
    else
      gtk=Qogir-Light icons=Qogir-Light cursor=Qogir palette="Catppuccin Latte"
    fi

    ${dconf} write ${interface}/gtk-theme "'$gtk'"
    ${dconf} write ${interface}/icon-theme "'$icons'"
    ${dconf} write ${interface}/cursor-theme "'$cursor'"
    ${dconf} write ${ptyxisProfile}/palette "'$palette'"
  '';

  follow = pkgs.writeShellScript "gnome-theme-follow" ''
    ${apply}
    ${dconf} watch ${interface}/color-scheme |
      while read -r line; do
        case "$line" in
          /*) ${apply} ;;
        esac
      done
  '';
in

{
  systemd.user.services.gnome-theme-follower = {
    Unit = {
      Description = "Follow the GNOME color scheme with Qogir and Catppuccin variants";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${follow}";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
