{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "Bluetooth-Battery-Meter@maniacx.github.com"
        "blur-my-shell@aunetx"
        "clipboard-indicator@tudmotu.com"
        "dash-to-dock@micxgx.gmail.com"
        "monitor@astraext.github.io"
        "simple-weather@romanlefler.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "org.gnome.TextEditor.desktop"
        "virt-manager.desktop"
        "chromium-browser.desktop"
        "firefox.desktop"
        "codium.desktop"
        "dev.zed.Zed.desktop"
        "lens-desktop.desktop"
        "bruno.desktop"
        "org.gnome.Ptyxis.desktop"
        "org.telegram.desktop.desktop"
        "spotify.desktop"
        "com.valvesoftware.Steam.desktop"
      ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      document-font-name = "Adwaita Sans 10";
      font-antialiasing = "rgba";
      font-hinting = "full";
      font-name = "Adwaita Sans 10";
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "Papirus-Dark";
      monospace-font-name = "Adwaita Mono 11";
    };

    "org/gnome/desktop/input-sources" = {
      sources = [
        (mkTuple [
          "xkb"
          "us+alt-intl"
        ])
      ];
      xkb-options = [ "lv3:switch" ]; # Make right ctrl alternate characters key
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 300;
      repeat-interval = lib.hm.gvariant.mkUint32 20;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "default";
      speed = -0.5;
    };

    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 900;
    };

    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-up = [ "<Super><Shift>Page_Up" ];
      move-to-workspace-down = [ "<Super><Shift>Page_Down" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-timeout = 0;
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
    };

    "org/gnome/mutter" = {
      experimental-features = [
        "scale-monitor-framebuffer"
        "variable-refresh-rate"
        "xwayland-native-scaling"
      ];
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-from = "18.0";
      night-light-schedule-to = "06.0";
      night-light-temperature = lib.hm.gvariant.mkUint32 4700;
    };

    "org/gnome/Ptyxis" = {
      cursor-blink-mode = "off";
      default-profile-uuid = "703ed983a52fe9b12a1a638b6941a022";
      font-name = "JetBrainsMono Nerd Font Mono 10";
      profile-uuids = [ "703ed983a52fe9b12a1a638b6941a022" ];
      restore-session = false;
      scrollbar-policy = "never";
      text-blink-mode = "never";
      use-system-font = false;
      window-size = mkTuple [
        (mkUint32 272)
        (mkUint32 63)
      ];
    };

    "org/gnome/Ptyxis/Profiles/703ed983a52fe9b12a1a638b6941a022" = {
      backspace-binding = "ascii-delete";
      cjk-ambiguous-width = "narrow";
      custom-command = "/etc/profiles/per-user/marcelo/bin/fish";
      delete-binding = "delete-sequence";
      label = "Default";
      limit-scrollback = false;
      palette = "Catppuccin Mocha";
      use-custom-command = true;
    };

    "org/gnome/nautilus/list-view" = {
      default-column-order = [
        "name"
        "size"
        "type"
        "owner"
        "group"
        "permissions"
        "date_modified"
        "date_accessed"
        "date_created"
        "recency"
        "detailed_type"
      ];
      default-visible-columns = [
        "name"
        "size"
        "type"
        "date_modified"
      ];
      default-zoom-level = "medium";
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      settings-version = 2;
    };

    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      brightness = 0.6;
      sigma = 30;
    };

    "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = true;
      brightness = 0.6;
      pipeline = "pipeline_default_rounded";
      sigma = 30;
      static-blur = true;
      style-dash-to-dock = 0;
    };

    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      brightness = 0.6;
      pipeline = "pipeline_default";
      sigma = 30;
    };

    "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/window-list" = {
      brightness = 0.6;
      sigma = 30;
    };

    "org/gnome/shell/extensions/clipboard-indicator" = {
      history-size = 100;
      move-item-first = true;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      background-opacity = 0.8;
      custom-theme-shrink = true;
      dash-max-icon-size = 48;
      dock-position = "BOTTOM";
      height-fraction = 0.9;
      hot-keys = false;
      intellihide-mode = "MAXIMIZED_WINDOWS";
      preferred-monitor = -2;
      preferred-monitor-by-connector = "DP-1";
      show-apps-at-top = true;
      animate-show-apps = true;
    };

    "org/gnome/shell/extensions/simple-weather" = {
      always-packaged-icons = false;
      is-activated = true;
      locations = [
        ''
          {"name":"Lagoa Santa","lat":-19.6301,"lon":-43.9009}
        ''
      ];
      my-loc-provider = "ipapi.co";
      panel-box = "center";
      symbolic-icons-panel = false;
      theme = "";
      unit-preset = "metric";
    };
  };
}
