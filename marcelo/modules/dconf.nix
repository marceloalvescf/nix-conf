{ lib, pkgs, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell" = {
      always-show-log-out = true;
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "Bluetooth-Battery-Meter@maniacx.github.com"
        "blur-my-shell@aunetx"
        "clipboard-indicator@tudmotu.com"
        "dash-to-dock@micxgx.gmail.com"
        "monitor@astraext.github.io"
        "nightthemeswitcher@romainvigier.fr"
        "rounded-window-corners@fxgn"
        "simple-weather@romanlefler.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "org.gnome.TextEditor.desktop"
        "virt-manager.desktop"
        "chromium-browser.desktop"
        "firefox.desktop"
        "com.anthropic.Claude.desktop"
        "code.desktop"
        "dev.zed.Zed.desktop"
        "lens-desktop.desktop"
        "org.gnome.Ptyxis.desktop"
        "org.telegram.desktop.desktop"
        "spotify.desktop"
        "steam.desktop"
      ];
    };

    "org/gnome/desktop/background" = {
      picture-uri = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/map-l.svg";
      picture-uri-dark = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/map-d.svg";
      picture-options = "zoom";
    };

    "org/gnome/desktop/interface" = {
      document-font-name = "SF Pro Text 10";
      font-antialiasing = "rgba";
      font-hinting = "full";
      font-name = "SF Pro Text 10";
      monospace-font-name = "SF Mono 11";
    };

    "org/gnome/shell/extensions/nightthemeswitcher/color-scheme" = {
      day = "prefer-light";
      night = "prefer-dark";
    };

    "org/gnome/shell/extensions/nightthemeswitcher/time" = {
      location = mkTuple [
        (mkDouble (-19.6))
        (mkDouble (-43.9))
      ];
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
      speed = -0.8;
    };

    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 900;
    };

    "org/gnome/desktop/notifications" = {
      show-in-lock-screen = false;
    };

    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-up = [ "<Super><Shift>Page_Up" ];
      move-to-workspace-down = [ "<Super><Shift>Page_Down" ];
    };

    # Spectacle-style capture: Print/Shift+Print go to Gradia, so the native
    # screenshot UI moves to Super+Print and its full-screen binding is freed.
    "org/gnome/shell/keybindings" = {
      screenshot = [ ];
      show-screenshot-ui = [ "<Super>Print" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gradia-region/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gradia-full/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/kooha/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gradia-region" = {
      name = "Screenshot region (Gradia)";
      binding = "Print";
      command = "${lib.getExe pkgs.gradia} --screenshot=INTERACTIVE";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gradia-full" = {
      name = "Screenshot full screen (Gradia)";
      binding = "<Shift>Print";
      command = "${lib.getExe pkgs.gradia} --screenshot=FULL";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/kooha" = {
      name = "Screen recorder (Kooha)";
      binding = "<Super><Shift>r";
      command = lib.getExe pkgs.kooha;
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
      night-light-schedule-automatic = true;
      night-light-schedule-from = 18.0;
      night-light-schedule-to = 6.0;
      night-light-last-coordinates = lib.hm.gvariant.mkTuple [
        "-19.60"
        "-43.90"
      ];
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

    # Mirrors the Plasma Resources Monitor and System Monitor widgets on
    # feature/plasma: icon-less graphs and readouts in the Qogir accent.
    "org/gnome/shell/extensions/astra-monitor" =
      let
        accent = "rgba(82,148,226,1.0)";
        profile = {
          monitors-order = builtins.toJSON [
            "processor"
            "sensors"
            "memory"
            "network"
            "storage"
            "gpu"
          ];
          headers-height-override = 0;
          gpu-header-show = false;

          processor-update = 1.0;
          processor-indicators-order = builtins.toJSON [
            "icon"
            "graph"
            "percentage"
            "frequency"
            "bar"
          ];
          processor-header-icon = false;
          processor-header-bars = false;
          processor-header-graph = true;
          processor-header-graph-breakdown = false;
          processor-header-graph-color1 = accent;
          processor-header-percentage = true;
          processor-header-frequency = true;
          processor-header-frequency-figures = 2;

          sensors-update = 1.0;
          sensors-indicators-order = builtins.toJSON [
            "icon"
            "value"
          ];
          sensors-header-show = true;
          sensors-header-icon = false;
          sensors-header-sensor1-show = true;
          # hwmon device key is "<name>-{$<PCI device id>}" for k10temp.
          sensors-header-sensor1 = builtins.toJSON {
            service = "hwmon";
            path = [
              "k10temp-{$1443}"
              "Tctl"
              "input"
            ];
          };
          sensors-header-sensor1-digits = 0;

          memory-update = 1.0;
          memory-unit = "KiB";
          memory-indicators-order = builtins.toJSON [
            "icon"
            "graph"
            "value"
            "percentage"
            "bar"
            "free"
          ];
          memory-header-icon = false;
          memory-header-bars = false;
          memory-header-graph = true;
          memory-header-graph-color1 = accent;
          memory-header-value = true;
          memory-header-percentage = true;

          network-update = 1.0;
          network-io-unit = "KiB/s";
          network-ignored = "[]";
          network-ignored-regex = "veth\\w{3,16}";
          network-indicators-order = builtins.toJSON [
            "icon"
            "IO graph"
            "IO speed"
            "IO bar"
          ];
          network-header-icon = false;
          network-header-graph = true;
          network-header-io = true;
          network-header-io-figures = 2;
          network-header-io-graph-color1 = accent;
          network-header-io-graph-color2 = "rgba(82,148,226,0.5)";

          storage-main = "name-nixos-rootfs";
          storage-indicators-order = builtins.toJSON [
            "icon"
            "bar"
            "percentage"
            "value"
            "free"
            "IO bar"
            "IO graph"
            "IO speed"
          ];
          storage-header-icon = false;
          storage-header-bars = true;
          storage-header-bars-color1 = accent;
          storage-header-percentage = true;
        };
      in
      profile
      // {
        headers-height = 0;
        # Astra copies the active profile back over the keys above on reset
        # or import, so it must carry the same values.
        profiles = builtins.toJSON { default = profile; };
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
      force-light-text = true;
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
