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

      mice = [
        {
          acceleration = -0.2;
          accelerationProfile = "none";
          enable = true;
          leftHanded = false;
          middleButtonEmulation = false;
          name = "Logitech MX Master 3S";
          naturalScroll = false;
          productId = "b034";
          scrollSpeed = 1;
          vendorId = "046d";
        }
      ];

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
          idleTimeout = 900;
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
                "applications:codium.desktop"
                "applications:dev.zed.Zed.desktop"
                "applications:lens-desktop.desktop"
                "applications:kitty.desktop"
                "applications:org.telegram.desktop.desktop"
                "applications:spotify.desktop"
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

    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
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
