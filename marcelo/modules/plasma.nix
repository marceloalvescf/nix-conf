{ pkgs, ... }:

{
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor.theme = "WhiteSur-cursors";
      iconTheme = "Papirus-Dark";
    };

    hotkeys.commands."launch-kitty" = {
      name = "Launch Kitty";
      key = "Meta+Alt+K";
      command = "kitty";
    };

    powerdevil = {
      AC = {
        powerButtonAction = "nothing";
        turnOffDisplay = {
          idleTimeout = 900;
          idleTimeoutWhenLocked = "immediately";
        };
      };
    };

    kscreenlocker = {
      lockOnResume = true;
      timeout = 10;
    };

    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
    };
  };
}
