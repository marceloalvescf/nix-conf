{ pkgs, ... }:

{
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      cursor.theme = "WhiteSur-cursors";
      iconTheme = "Papirus-Dark";
      lookAndFeel = "org.kde.breezedark.desktop";
      wallpaper = "/home/marcelo/Pictures/Wallpapers/dodgechallenger.jpg";
      wallpaperBackground.blur = true;
    };

    fonts = {
      fixedWidth = {
        family = "IBM Plex Mono";
        pointSize = 10;
      };
      general = {
        family = "IBM Plex Sans";
        pointSize = 10;
      };
      menu = {
        family = "IBM Plex Sans";
        pointSize = 10;
      };
      small = {
        family = "IBM Plex Sans";
        pointSize = 8;
      };
      toolbar = {
        family = "IBM Plex Sans";
        pointSize = 10;
      };
      windowTitle = {
        family = "IBM Plex Sans";
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

    panels = [
      {
        location = "bottom";
        widgets = [
          {
            name = "weather.widget.plus";
            config = {
              Appearance.widgetFontSize = 15;
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
            name = "AndromedaLauncher";
            config.General = {
              enableGlow = true;
              floating = true;
              glowColor = 1;
              launcherPosition = 1;
              useSystemFontSettings = true;
            };
          }
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.kate.desktop"
                "applications:virt-manager.desktop"
                "applications:chromium-browser.desktop"
                "applications:firefox.desktop"
                "applications:com.anthropic.Claude.desktop"
                "applications:chatgpt.desktop"
                "applications:code.desktop"
                "applications:dev.zed.Zed.desktop"
                "applications:lens-desktop.desktop"
                "applications:kitty.desktop"
                "applications:org.telegram.desktop.desktop"
                "applications:spotify.desktop"
                "applications:steam.desktop"
              ];
              behavior.showTasks = {
                onlyInCurrentDesktop = false;
                onlyInCurrentActivity = false;
              };
              settings.General.fill = false;
            };
          }
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.marginsseparator"
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
            systemTray.items = {
              # devicenotifier and brightness intentionally absent: "never show".
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
              ];
            };
          }
          "org.kde.plasma.digitalclock"
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
      "kdeglobals"."General"."BrowserApplication" = "firefox.desktop";
      "kdeglobals"."General"."XftAntialias" = true;
      "kdeglobals"."General"."XftHintStyle" = "hintfull";
      "kdeglobals"."General"."XftSubPixel" = "rgb";
      "kwinrc"."TabBox"."ActivitiesMode" = 0;
      "kwinrc"."TabBox"."DesktopMode" = 0;
      "kwinrc"."Xwayland"."Scale" = 1.75;
      "kxkbrc"."Layout"."Options" = "lv3:switch";
      "kxkbrc"."Layout"."ResetOldOptions" = true;
      "kxkbrc"."Layout"."Use" = true;
    };
  };

  # BrowserApplication above only covers KDE apps and kde-open; xdg-open and
  # non-KDE callers resolve through mimeapps.list. Home Manager writes that file
  # as a store symlink, so it becomes read-only and applications can no longer
  # register themselves — every handler has to be declared here, including the
  # claude scheme that Claude Desktop used to add on its own.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/xhtml+xml" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/claude" = "com.anthropic.Claude.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  home.packages = [
    (pkgs.callPackage ../../pkgs/plasmoids/andromeda-launcher.nix { })
    (pkgs.callPackage ../../pkgs/plasmoids/resources-monitor.nix { })
    (pkgs.callPackage ../../pkgs/plasmoids/weather-widget-plus.nix { })
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
