{ pkgs, config, lib, ... }:

{
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor.theme = "WhiteSur-cursors";
      iconTheme = "Papirus-Dark";
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
      lockOnResume = true;
      timeout = 5;
    };

    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      "kdeglobals"."General"."XftAntialias" = true;
      "kdeglobals"."General"."XftHintStyle" = "hintfull";
      "kdeglobals"."General"."XftSubPixel" = "rgb";
      "kwinrc"."Xwayland"."Scale" = 1.75;
      "kxkbrc"."Layout"."Options" = "lv3:switch";
      "kxkbrc"."Layout"."ResetOldOptions" = true;
      "kxkbrc"."Layout"."Use" = true;
    };
  };

  # Pinned task manager icons go blank after a rebuild because Plasma
  # stores absolute /nix/store paths to .desktop files in its config,
  # which become stale once the old store paths are garbage collected.
  # Rewrite them to generic application references on every activation.
  home.activation.cleanPlasmaLaunchers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD sed -i 's|file:///nix/store/[^/]*/share/applications/|applications:|g' \
      ${config.home.homeDirectory}/.config/plasma-org.kde.plasma.desktop-appletsrc || true
  '';

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style = {
      name = "breeze";
      package = pkgs.kdePackages.breeze;
    };
  };
}
