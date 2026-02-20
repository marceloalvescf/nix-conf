{ ... }:

{
  # System services related settings
  services = {
    # required for yubikey communication
    pcscd.enable = true;

    # Enable OpenSSH daemon
    openssh.enable = true;

    # Enable power-profiles-daemon service
    power-profiles-daemon.enable = true;

    # Disable CUPS
    printing.enable = false;

    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
}
