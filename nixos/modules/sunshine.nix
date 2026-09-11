{ ... }:

{
  services.sunshine = {
    enable = true;
    autoStart = true;

    # DRM/KMS capture for the Wayland-only session.
    capSysAdmin = true;

    openFirewall = true;
  };
}
