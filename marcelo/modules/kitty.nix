{ ... }:

{
  programs.kitty = {
    enable = true;

    # Must go through this option, not settings.shell_integration: home-manager
    # always emits its own shell_integration line, and a second one from
    # settings silently replaces it instead of merging.
    shellIntegration.mode = "no-cursor";

    autoThemeFiles = {
      light = "Catppuccin-Latte";
      dark = "Catppuccin-Mocha";
      noPreference = "Catppuccin-Mocha";
    };

    settings = {
      linux_display_server = "wayland";
      shell = "fish";
      term = "xterm-256color";
      font_family = "JetBrainsMono Nerd Font Mono";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = "11";
      cursor_shape = "block";
      open_url_with = "default";
      detect_urls = "yes";
      sync_to_monitor = "yes";
      remember_window_size = "yes";
      initial_window_width = "1600";
      initial_window_height = "900";
      window_margin_width = "15";

      # OS Window titlebar colors
      wayland_titlebar_color = "system";
      macos_titlebar_color = "system";
    };
  };
}
