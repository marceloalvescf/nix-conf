{ ... }:

let
  browser = "firefox.desktop";
in
{
  # Without explicit defaults GNOME picks Chromium, which wins the
  # home-manager profile's mimeinfo.cache over the system Firefox entry.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = browser;
      "application/xhtml+xml" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
      # Registered at runtime by Claude Code; kept here because home-manager now owns the file.
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
    };
  };

  # Replace the imperative mimeapps.list instead of aborting activation on it.
  xdg.configFile."mimeapps.list".force = true;
}
