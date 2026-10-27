{ config, pkgs, ... }:

let
  dconf = "${pkgs.dconf}/bin/dconf";
  interface = "/org/gnome/desktop/interface";
  kvantumDir = "${config.xdg.configHome}/Kvantum";
  ptyxisProfile = "/org/gnome/Ptyxis/Profiles/${
    config.dconf.settings."org/gnome/Ptyxis".default-profile-uuid
  }";

  apply = pkgs.writeShellScript "gnome-theme-apply" ''
    if [ "$(${dconf} read ${interface}/color-scheme)" = "'prefer-dark'" ]; then
      gtk=Qogir-Round-Dark icons=Qogir-Dark cursor=Qogir-Dark kvantum=Qogir-dark-solid
      palette="Catppuccin Mocha"
    else
      gtk=Qogir-Round-Light icons=Qogir-Light cursor=Qogir kvantum=Qogir-light-solid
      palette="Catppuccin Latte"
    fi

    ${dconf} write ${interface}/gtk-theme "'$gtk'"
    ${dconf} write ${interface}/icon-theme "'$icons'"
    ${dconf} write ${interface}/cursor-theme "'$cursor'"
    ${dconf} write ${ptyxisProfile}/palette "'$palette'"
    mkdir -p ${kvantumDir}
    printf '[General]\ntheme=%s\n' "$kvantum" > ${kvantumDir}/kvantum.kvconfig
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
      Description = "Follow the GNOME color scheme with Qogir, Kvantum, and Catppuccin variants";
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
