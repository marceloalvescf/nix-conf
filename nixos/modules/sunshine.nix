{ ... }:

{
  services.sunshine = {
    enable = true;
    autoStart = true;

    # DRM/KMS capture — required on KDE Wayland (no X11).
    capSysAdmin = true;

    openFirewall = true;
  };
}
