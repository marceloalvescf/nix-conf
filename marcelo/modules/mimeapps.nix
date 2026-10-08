{ ... }:

let
  browser = "firefox.desktop";
in
{
  # kdeglobals BrowserApplication (plasma.nix) only covers KDE apps and
  # kde-open; xdg-open and non-KDE callers resolve through mimeapps.list.
  # Home Manager owns that file, so applications can no longer register
  # handlers themselves and every scheme has to be declared here.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = browser;
      "application/xhtml+xml" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
      "x-scheme-handler/claude" = "com.anthropic.Claude.desktop";
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
    };
  };

  # Replace the imperative mimeapps.list instead of aborting activation on it.
  xdg.configFile."mimeapps.list".force = true;
}
