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

      # Required prerequisite for the Echo Dot A2DP sink rule below.
      # Without these codec and role settings, WirePlumber fails to negotiate
      # the A2DP profile and the device-specific auto-connect rule has no effect.
      wireplumber.extraConfig.bluetoothEnhancements = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.headset-roles" = [
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
          ];
        };
      };

      # Force Echo Dot to connect as A2DP sink (speaker) instead of audio-gateway.
      # Without this, BlueZ negotiates the wrong profile and the device appears as input.
      # See: https://github.com/bluez/bluez/issues/1922
      wireplumber.extraConfig.echoAutoConnect = {
        "monitor.bluez.rules" = [
          {
            matches = [ { "device.name" = "bluez_card.18_0B_1B_EA_8B_1C"; } ];
            actions = {
              "update-props" = {
                "bluez5.auto-connect" = [ "a2dp_sink" ];
              };
            };
          }
        ];
      };
    };
  };
}
