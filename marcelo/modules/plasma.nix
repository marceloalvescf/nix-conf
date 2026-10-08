{
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  rootDisk = "disk/${lib.removePrefix "/dev/disk/by-uuid/" osConfig.fileSystems."/".device}";
  rootDiskFace = "starscream.ksysguard.piechart-small";

  # home-manager uses useGlobalPkgs, so there's no per-user overlay to hook
  # the flake input into; apply its overlay function locally instead.
  appgrid = (inputs.appgrid.overlays.default pkgs pkgs).appgrid;

  # Upstream's dark look-and-feel names a cursor theme that does not exist (the
  # icon pack ships Qogir-Dark), and both pick Kvantum, whose dark-variant
  # lookup does not match Qogir's folder names. Breeze follows the colour scheme.
  # The dialog and tooltip SVGs also carry a leftover Inkscape <style> with
  # light Breeze colours after the current-color-scheme block Plasma recolours,
  # so it wins and paints popups and tooltips light under Qogir-dark.
  qogir-kde = pkgs.qogir-kde.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      lnf=$out/share/plasma/look-and-feel/com.github.vinceliuice.Qogir
      substituteInPlace $lnf-dark/contents/defaults \
        --replace-fail cursorTheme=Qogir-dark cursorTheme=Qogir-Dark \
        --replace-fail widgetStyle=kvantum-dark widgetStyle=Breeze
      substituteInPlace $lnf-light/contents/defaults \
        --replace-fail widgetStyle=kvantum widgetStyle=Breeze

      find $out/share/plasma/desktoptheme -name '*.svg' -exec \
        sed -i -E -z 's#<style[^>]*id="style(8|22)"[^>]*>[^<]*ColorScheme-[^<]*</style>##g' {} +
      if grep -rlzE 'id="style(8|22)"[^>]*>[^<]*ColorScheme-' $out/share/plasma/desktoptheme; then
        echo "stray Qogir colour-scheme styles left" >&2
        exit 1
      fi
    '';
  });
in

{
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      wallpaper = "/home/marcelo/Pictures/Wallpapers/nixos-blue.png";
      wallpaperBackground.blur = true;
    };

    fonts = {
      fixedWidth = {
        family = "SF Mono";
        pointSize = 10;
      };
      general = {
        family = "SF Pro Text";
        pointSize = 10;
      };
      menu = {
        family = "SF Pro Text";
        pointSize = 10;
      };
      small = {
        family = "SF Pro Text";
        pointSize = 8;
      };
      toolbar = {
        family = "SF Pro Text";
        pointSize = 10;
      };
      windowTitle = {
        family = "SF Pro Display";
        pointSize = 10;
      };
    };

    hotkeys.commands."launch-kitty" = {
      name = "Launch Kitty";
      key = "Meta+Alt+K";
      command = "kitty";
    };

    input = {
      keyboard = {
        layouts = [
          {
            layout = "us";
            variant = "alt-intl";
          }
        ];
        repeatDelay = 250;
        repeatRate = 50.0;
      };

      # Attack Shark X11 on its own 2.4G dongle. libinput reports the receiver
      # name, not the mouse model, and plasma-manager keys kcminputrc on it.
      mice = [
        {
          acceleration = -1.0;
          accelerationProfile = "default";
          enable = true;
          leftHanded = false;
          middleButtonEmulation = false;
          name = "LXDDZ 2.4G Wireless Device";
          naturalScroll = false;
          productId = "fa60";
          scrollSpeed = 1;
          vendorId = "1d57";
        }
      ];
    };

    kwin.nightLight = {
      enable = true;
      mode = "location";
      location = {
        latitude = "-19.60";
        longitude = "-43.90";
      };
      temperature.night = 5000;
    };

    powerdevil = {
      AC = {
        autoSuspend.action = "nothing";
        dimDisplay = {
          enable = true;
          idleTimeout = 300;
        };
        powerButtonAction = "nothing";
        powerProfile = "balanced";
        turnOffDisplay = {
          idleTimeout = 1200;
          idleTimeoutWhenLocked = "immediately";
        };
      };
    };

    kscreenlocker = {
      appearance = {
        showMediaControls = false;
        wallpaperPictureOfTheDay.provider = "bing";
      };
      autoLock = true;
      lockOnResume = true;
      passwordRequired = true;
      passwordRequiredDelay = 5;
      timeout = 15;
    };

    kwin.virtualDesktops = {
      number = 3;
      rows = 1;
    };

    panels = [
      {
        location = "top";
        height = 38;
        floating = false;
        hiding = "none";
        opacity = "adaptive";
        widgets = [
          {
            # kara pager, "Pills" style (type 0); its kcfg group is lowercase "general".
            name = "org.dhruv8sh.kara";
            config.general.type = 0;
          }
          "org.kde.plasma.panelspacer"
          {
            digitalClock = {
              date = {
                enable = true;
                format.custom = "MMM d";
                position = "besideTime";
              };
              time = {
                format = "12h";
                showSeconds = "never";
              };
              # Matches the weather widget's 15 px text: the clock converts
              # points with the screen's ~88 DPI (3840 px / 1.75 over 632 mm).
              # weight defaults to Qt 5's 50, which Qt 6 renders as thin.
              font = {
                family = "SF Pro Text";
                size = 11;
                weight = 400;
              };
            };
          }
          {
            name = "weather.widget.plus";
            config = {
              Appearance.widgetFontSize = 13;
              Location = {
                firstRun = false;
                places = builtins.toJSON [
                  {
                    providerId = "om";
                    placeIdentifier = "latitude=-19.6&longitude=-43.9&altitude=800";
                    placeAlias = "Home";
                    timezoneID = 68;
                  }
                ];
              };
              Units = {
                temperatureType = "celsius";
                pressureType = "hPa";
                windSpeedType = "kmh";
              };
            };
          }
          "org.kde.plasma.panelspacer"
          {
            name = "org.kde.plasma.resources-monitor";
            config.General.graphs = builtins.toJSON [
              {
                "_v" = 3;
                type = "cpu";
                sizes = [
                  (-1)
                  (-1)
                ];
                colors = [
                  "highlightColor"
                  "textColor"
                  "textColor"
                ];
                sensorsType = [
                  "usage"
                  "classic"
                  true
                ];
                clockAggregator = "average";
                eCoresCount = 0;
                thresholds = [
                  85
                  105
                ];
              }
              {
                "_v" = 3;
                type = "memory";
                sizes = [
                  (-1)
                  (-1)
                ];
                colors = [
                  "highlightColor"
                  "negativeTextColor"
                ];
                sensorsType = [
                  "physical"
                  "memory-percent"
                ];
                thresholds = [
                  70
                  90
                ];
              }
              {
                "_v" = 3;
                type = "network";
                sizes = [
                  (-1)
                  (-1)
                ];
                colors = [
                  "highlightColor"
                  "positiveTextColor"
                ];
                sensorsType = [
                  false
                  "kibibyte"
                ];
                uplimits = [
                  100000
                  100000
                ];
                ignoredInterfaces = [
                  "veth90cb290"
                  "vethfd6a27f"
                  "veth1c47d10"
                  "vethc8744f3"
                  "vetha83fa94"
                  "vetha8d7764"
                  "vetha7e93a6"
                  "veth6c01526"
                ];
                icons = true;
              }
            ];
          }
          {
            systemMonitor = {
              title = "Root";
              showTitle = false;
              displayStyle = rootDiskFace;
              sensors = [
                {
                  name = "${rootDisk}/usedPercent";
                  color = "61,174,233";
                  label = "Root";
                }
              ];
              totalSensors = [ "${rootDisk}/usedPercent" ];
              textOnlySensors = [
                "${rootDisk}/used"
                "${rootDisk}/free"
                "${rootDisk}/total"
              ];
              # plasma-manager writes `range` to the stock piechart group only.
              settings."${rootDiskFace}/General" = {
                rangeAuto = false;
                rangeFrom = 0;
                rangeTo = 100;
              };
            };
          }
          {
            systemTray.items = {
              # devicenotifier intentionally absent: "never show".
              extra = [
                "org.kde.plasma.cameraindicator"
                "org.kde.plasma.clipboard"
                "org.kde.plasma.manage-inputmethod"
                "org.kde.plasma.mediacontroller"
                "org.kde.plasma.notifications"
                "org.kde.kscreen"
                "org.kde.plasma.battery"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.keyboardindicator"
                "org.kde.plasma.keyboardlayout"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
                "org.kde.plasma.weather"
                "org.kde.plasma.brightness"
              ];
            };
          }
          {
            name = "org.kde.plasma.shutdownorswitch";
            config.General = {
              showLockScreen = true;
              showLogOut = true;
              showSuspend = true;
              showRestart = true;
              showShutdown = true;
              showHibernate = false;
              showSuspendThenHibernate = false;
              showNewSession = false;
              showUsers = false;
              showName = false;
            };
          }
        ];
      }
      {
        location = "bottom";
        alignment = "center";
        lengthMode = "fit";
        floating = true;
        hiding = "dodgewindows";
        opacity = "translucent";
        height = 56;
        widgets = [
          # Centered AppGrid launcher. Both AppGrid plasmoids declare
          # X-Plasma-Provides: org.kde.plasma.launchermenu, so KWin's
          # Meta-only modifier shortcut opens this without extra config.
          "dev.xarbit.appgrid"
          "org.kde.plasma.marginsseparator"
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.kate.desktop"
                "applications:virt-manager.desktop"
                "applications:chromium-browser.desktop"
                "applications:firefox.desktop"
                "applications:com.anthropic.Claude.desktop"
                "applications:code.desktop"
                "applications:dev.zed.Zed.desktop"
                "applications:lens-desktop.desktop"
                "applications:kitty.desktop"
                "applications:org.telegram.desktop.desktop"
                "applications:spotify.desktop"
                "applications:steam.desktop"
              ];
              appearance = {
                showTooltips = true;
                highlightWindows = true;
                indicateAudioStreams = true;
                iconSpacing = "medium";
                fill = false;
              };
              behavior = {
                grouping = {
                  method = "byProgramName";
                  clickAction = "showPresentWindowsEffect";
                };
                sortingMethod = "manually";
                minimizeActiveTaskOnClick = true;
                showTasks = {
                  onlyInCurrentDesktop = false;
                  onlyInCurrentActivity = false;
                };
              };
            };
          }
        ];
      }
    ];

    # Display Configuration (scale 175%, adaptive sync Automatic, colour profile
    # Built-in/EDID) stays manual: KWin keeps it in kwinoutputconfig.json, keyed
    # by monitor EDID hash, and rewrites it at runtime for brightness and
    # hotplug. plasma-manager has no module for it, and a store symlink would
    # stop KWin from saving. Only the XWayland half below is declarative.
    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      # Plasma swaps these at Night Light's sunrise/sunset. Each switch applies
      # the whole package (colours, icons, cursor, Plasma theme, decoration),
      # so none of those parts is set on its own.
      "kdeglobals"."KDE"."AutomaticLookAndFeel" = true;
      "kdeglobals"."KDE"."DefaultDarkLookAndFeel" = "com.github.vinceliuice.Qogir-dark";
      "kdeglobals"."KDE"."DefaultLightLookAndFeel" = "com.github.vinceliuice.Qogir-light";
      "kdeglobals"."General"."BrowserApplication" = "firefox.desktop";
      "kdeglobals"."General"."XftAntialias" = true;
      "kdeglobals"."General"."XftHintStyle" = "hintfull";
      "kdeglobals"."General"."XftSubPixel" = "rgb";
      # Top-left screen edge (ElectricTopLeft = 7) opens Overview, like GNOME's
      # Activities corner; this is KWin's default, pinned here.
      "kwinrc"."Effect-overview"."BorderActivate" = 7;
      "kwinrc"."TabBox"."ActivitiesMode" = 0;
      "kwinrc"."TabBox"."DesktopMode" = 0;
      "kwinrc"."Xwayland"."Scale" = 1.75;
      "kxkbrc"."Layout"."Options" = "lv3:switch";
      "kxkbrc"."Layout"."ResetOldOptions" = true;
      "kxkbrc"."Layout"."Use" = true;
    };

    # Plasma's GTK sync owns the GTK settings files and rewrites icons, cursor,
    # font, button layout and the dark preference from the active global theme;
    # only the theme name is set here. Qogir-Light's dark variant is Qogir-Dark.
    startup.startupScript."gtk_theme".text = ''
      ${pkgs.dbus}/bin/dbus-send --session --print-reply --type=method_call \
        --dest=org.kde.GtkConfig /GtkConfig org.kde.GtkConfig.setGtkTheme string:Qogir-Light
    '';
  };

  home.packages = [
    qogir-kde
    pkgs.qogir-icon-theme
    pkgs.qogir-theme
    appgrid
    (pkgs.callPackage ../../pkgs/plasmoids/resources-monitor.nix { })
    (pkgs.callPackage ../../pkgs/plasmoids/shutdown-or-switch.nix { })
    (pkgs.callPackage ../../pkgs/plasmoids/weather-widget-plus.nix { })
    (pkgs.callPackage ../../pkgs/sensorfaces/piechart-small.nix { })
  ];

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style = {
      name = "breeze";
      package = pkgs.kdePackages.breeze;
    };
  };
}
