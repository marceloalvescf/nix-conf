{ ... }:

{
  services.sunshine = {
    enable = true;
    autoStart = true;

    # DRM/KMS capture — required on KDE Wayland (no X11).
    capSysAdmin = true;

    openFirewall = true;
  };

  # The upstream sunshine module still sets the obsolete avahi.publish options
  # (mkDefault) for Moonlight discovery; null them and use the settings form.
  services.avahi = {
    publish = {
      enable = null;
      userServices = null;
    };
    settings.publish = {
      disable-publishing = false;
      disable-user-service-publishing = false;
      publish-addresses = true;
    };
  };
}
