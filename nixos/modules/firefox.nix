{ ... }:

{
  programs.firefox = {
    enable = true;

    # "default" keeps these overridable in about:config instead of locked.
    preferencesStatus = "default";
    preferences = {
      # Native Wayland fractional scaling drops YouTube frames and lags the UI
      # on the 4K panel at 166%.
      "widget.wayland.fractional-scale.enabled" = false;
    };
  };
}
