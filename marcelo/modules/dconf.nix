{ lib, ... }:

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

    "org/gnome/shell/extensions/astra-monitor" = {
      gpu-indicators-order = "[\"icon\",\"activity bar\",\"activity graph\",\"activity percentage\",\"memory bar\",\"memory graph\",\"memory percentage\",\"memory value\"]";
      headers-height = 0;
      headers-height-override = 0;
      memory-indicators-order = "[\"icon\",\"bar\",\"graph\",\"percentage\",\"value\",\"free\"]";
      memory-update = 1.0;
      monitors-order = "[\"processor\",\"gpu\",\"memory\",\"storage\",\"network\",\"sensors\"]";
      network-header-graph = false;
      network-header-graph-width = 30;
      network-header-io = true;
      network-header-io-figures = 3;
      network-header-io-layout = "vertical";
      network-ignored = "[]";
      network-ignored-regex = "veth\\w{3,16}";
      network-indicators-order = "[\"icon\",\"IO bar\",\"IO graph\",\"IO speed\"]";
      network-update = 0.99999999999999967;
      processor-header-bars = true;
      processor-header-graph = false;
      processor-indicators-order = "[\"icon\",\"bar\",\"graph\",\"percentage\",\"frequency\"]";
      processor-menu-gpu-color = "";
      processor-update = 0.99999999999999967;
      profiles = builtins.toJSON {
        default = {
          compact-mode = false;
          compact-mode-activation = "both";
          compact-mode-compact-icon-custom = "";
          compact-mode-expanded-icon-custom = "";
          compact-mode-start-expanded = false;
          explicit-zero = false;
          gpu-data = "[]";
          gpu-header-activity-bar = true;
          gpu-header-activity-bar-color1 = "rgba(29,172,214,1.0)";
          gpu-header-activity-graph = false;
          gpu-header-activity-graph-color1 = "rgba(29,172,214,1.0)";
          gpu-header-activity-graph-width = 30;
          gpu-header-activity-percentage = false;
          gpu-header-activity-percentage-icon-alert-threshold = 0;
          gpu-header-icon = true;
          gpu-header-icon-alert-color = "rgba(235, 64, 52, 1)";
          gpu-header-icon-color = "";
          gpu-header-icon-custom = "";
          gpu-header-icon-size = 18;
          gpu-header-memory-bar = true;
          gpu-header-memory-bar-color1 = "rgba(29,172,214,1.0)";
          gpu-header-memory-graph = false;
          gpu-header-memory-graph-color1 = "rgba(29,172,214,1.0)";
          gpu-header-memory-graph-width = 30;
          gpu-header-memory-percentage = false;
          gpu-header-memory-percentage-icon-alert-threshold = 0;
          gpu-header-show = false;
          gpu-header-tooltip = true;
          gpu-header-tooltip-activity-percentage = true;
          gpu-header-tooltip-memory-percentage = true;
          gpu-header-tooltip-memory-value = true;
          gpu-indicators-order = "\"\"";
          gpu-update = 2;
          headers-font-family = "";
          headers-font-size = 0;
          headers-height-override = 0;
          memory-header-bars = true;
          memory-header-bars-breakdown = true;
          memory-header-bars-color1 = "rgba(29,172,214,1.0)";
          memory-header-bars-color2 = "rgba(29,172,214,0.3)";
          memory-header-free = false;
          memory-header-free-figures = 3;
          memory-header-free-icon-alert-threshold = 0;
          memory-header-graph = false;
          memory-header-graph-breakdown = false;
          memory-header-graph-color1 = "rgba(29,172,214,1.0)";
          memory-header-graph-color2 = "rgba(29,172,214,0.3)";
          memory-header-graph-width = 30;
          memory-header-icon = true;
          memory-header-icon-alert-color = "rgba(235, 64, 52, 1)";
          memory-header-icon-color = "";
          memory-header-icon-custom = "";
          memory-header-icon-size = 18;
          memory-header-percentage = false;
          memory-header-percentage-icon-alert-threshold = 0;
          memory-header-show = true;
          memory-header-tooltip = true;
          memory-header-tooltip-free = false;
          memory-header-tooltip-percentage = true;
          memory-header-tooltip-value = true;
          memory-header-value = false;
          memory-header-value-figures = 3;
          memory-indicators-order = "\"\"";
          memory-menu-graph-breakdown = true;
          memory-menu-swap-color = "rgba(29,172,214,1.0)";
          memory-source-memory-usage = "auto";
          memory-source-top-processes = "auto";
          memory-unit = "kB-KB";
          memory-update = 1;
          memory-used = "total-free-buffers-cached";
          monitors-order = "\"\"";
          network-header-bars = false;
          network-header-graph = false;
          network-header-graph-width = 30;
          network-header-icon = true;
          network-header-icon-alert-color = "rgba(235, 64, 52, 1)";
          network-header-icon-color = "";
          network-header-icon-custom = "";
          network-header-icon-size = 18;
          network-header-io = true;
          network-header-io-bars-color1 = "rgba(29,172,214,1.0)";
          network-header-io-bars-color2 = "rgba(214,29,29,1.0)";
          network-header-io-figures = 3;
          network-header-io-graph-color1 = "rgba(29,172,214,1.0)";
          network-header-io-graph-color2 = "rgba(214,29,29,1.0)";
          network-header-io-layout = "vertical";
          network-header-io-threshold = 0;
          network-header-show = true;
          network-header-tooltip = true;
          network-header-tooltip-io = true;
          network-ignored = "[]";
          network-ignored-regex = "veth\\w{3,16}";
          network-indicators-order = "\"\"";
          network-io-unit = "kB/s";
          network-menu-arrow-color1 = "rgba(29,172,214,1.0)";
          network-menu-arrow-color2 = "rgba(214,29,29,1.0)";
          network-source-network-io = "auto";
          network-source-public-ipv4 = "https://api.ipify.org";
          network-source-public-ipv6 = "https://api6.ipify.org";
          network-source-top-processes = "auto";
          network-source-wireless = "auto";
          network-update = 1;
          panel-box = "right";
          panel-box-order = 0;
          panel-margin-left = 0;
          panel-margin-right = 0;
          processor-gpu = true;
          processor-header-bars = true;
          processor-header-bars-breakdown = true;
          processor-header-bars-color1 = "rgba(29,172,214,1.0)";
          processor-header-bars-color2 = "rgba(214,29,29,1.0)";
          processor-header-bars-core = false;
          processor-header-frequency = false;
          processor-header-frequency-figures = 3;
          processor-header-frequency-mode = "average";
          processor-header-graph = false;
          processor-header-graph-breakdown = true;
          processor-header-graph-color1 = "rgba(29,172,214,1.0)";
          processor-header-graph-color2 = "rgba(214,29,29,1.0)";
          processor-header-graph-width = 30;
          processor-header-icon = true;
          processor-header-icon-alert-color = "rgba(235, 64, 52, 1)";
          processor-header-icon-color = "";
          processor-header-icon-custom = "";
          processor-header-icon-size = 18;
          processor-header-percentage = false;
          processor-header-percentage-core = false;
          processor-header-percentage-icon-alert-threshold = 0;
          processor-header-show = true;
          processor-header-tooltip = true;
          processor-header-tooltip-percentage = true;
          processor-header-tooltip-percentage-core = false;
          processor-indicators-order = "\"\"";
          processor-menu-bars-breakdown = true;
          processor-menu-core-bars-breakdown = true;
          processor-menu-graph-breakdown = true;
          processor-menu-top-processes-percentage-core = true;
          processor-source-cpu-cores-usage = "auto";
          processor-source-cpu-usage = "auto";
          processor-source-load-avg = "auto";
          processor-source-top-processes = "auto";
          processor-update = 1;
          sensors-header-icon = true;
          sensors-header-icon-alert-color = "rgba(235, 64, 52, 1)";
          sensors-header-icon-color = "";
          sensors-header-icon-custom = "";
          sensors-header-icon-size = 18;
          sensors-header-sensor1 = "\"\"";
          sensors-header-sensor1-digits = -1;
          sensors-header-sensor1-show = false;
          sensors-header-sensor2 = "\"\"";
          sensors-header-sensor2-digits = -1;
          sensors-header-sensor2-layout = "vertical";
          sensors-header-sensor2-show = false;
          sensors-header-show = false;
          sensors-header-tooltip = false;
          sensors-header-tooltip-sensor1 = "\"\"";
          sensors-header-tooltip-sensor1-digits = -1;
          sensors-header-tooltip-sensor1-name = "";
          sensors-header-tooltip-sensor2 = "\"\"";
          sensors-header-tooltip-sensor2-digits = -1;
          sensors-header-tooltip-sensor2-name = "";
          sensors-header-tooltip-sensor3 = "\"\"";
          sensors-header-tooltip-sensor3-digits = -1;
          sensors-header-tooltip-sensor3-name = "";
          sensors-header-tooltip-sensor4 = "\"\"";
          sensors-header-tooltip-sensor4-digits = -1;
          sensors-header-tooltip-sensor4-name = "";
          sensors-header-tooltip-sensor5 = "\"\"";
          sensors-header-tooltip-sensor5-digits = -1;
          sensors-header-tooltip-sensor5-name = "";
          sensors-ignored-attribute-regex = "";
          sensors-ignored-category-regex = "";
          sensors-ignored-regex = "";
          sensors-indicators-order = "\"\"";
          sensors-source = "auto";
          sensors-temperature-unit = "celsius";
          sensors-update = 1;
          shell-bar-position = "top";
          startup-delay = 2;
          storage-header-bars = true;
          storage-header-bars-color1 = "rgba(29,172,214,1.0)";
          storage-header-free = false;
          storage-header-free-figures = 3;
          storage-header-free-icon-alert-threshold = 0;
          storage-header-graph = false;
          storage-header-graph-width = 30;
          storage-header-icon = true;
          storage-header-icon-alert-color = "rgba(235, 64, 52, 1)";
          storage-header-icon-color = "";
          storage-header-icon-custom = "";
          storage-header-icon-size = 18;
          storage-header-io = false;
          storage-header-io-bars = false;
          storage-header-io-bars-color1 = "rgba(29,172,214,1.0)";
          storage-header-io-bars-color2 = "rgba(214,29,29,1.0)";
          storage-header-io-figures = 2;
          storage-header-io-graph-color1 = "rgba(29,172,214,1.0)";
          storage-header-io-graph-color2 = "rgba(214,29,29,1.0)";
          storage-header-io-layout = "vertical";
          storage-header-io-threshold = 0;
          storage-header-percentage = false;
          storage-header-percentage-icon-alert-threshold = 0;
          storage-header-show = true;
          storage-header-tooltip = true;
          storage-header-tooltip-free = true;
          storage-header-tooltip-io = true;
          storage-header-tooltip-percentage = true;
          storage-header-tooltip-value = false;
          storage-header-value = false;
          storage-header-value-figures = 3;
          storage-ignored = "\"[]\"";
          storage-ignored-regex = "";
          storage-indicators-order = "\"\"";
          storage-io-unit = "kB/s";
          storage-main = "[default]";
          storage-menu-arrow-color1 = "rgba(29,172,214,1.0)";
          storage-menu-arrow-color2 = "rgba(214,29,29,1.0)";
          storage-menu-device-color = "rgba(29,172,214,1.0)";
          storage-source-storage-io = "auto";
          storage-source-storage-usage = "auto";
          storage-source-top-processes = "auto";
          storage-update = 3;
          theme-style = "dark";
        };
      };
      sensors-header-show = false;
      sensors-indicators-order = "[\"icon\",\"value\"]";
      sensors-update = 1.0;
      storage-indicators-order = "[\"icon\",\"bar\",\"percentage\",\"value\",\"free\",\"IO bar\",\"IO graph\",\"IO speed\"]";
      storage-main = "name-nixos-rootfs";
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
