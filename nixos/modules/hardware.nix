{ pkgs, ... }:

{
  # Hardware related settings
  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true; # Enable AMD microcode updates
    i2c.enable = true; # Enable I2C devices

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
        libglvnd
      ];
    };
  };

  # Attack Shark X11 (1d57): fa60 dongle 2.4G, fa55 X11 wired, fa61 R1 wired.
  # hidraw for node-hid tools, usb for libusb ones.
  #
  # Not services.udev.extraRules: that lands in 99-local.rules, but systemd
  # turns the uaccess tag into an ACL from 73-seat-late.rules, so a tag set at
  # 99 is never acted on. Any prefix below 73 works.
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "attack-shark-x11-udev-rules";
      destination = "/etc/udev/rules.d/60-attack-shark-x11.rules";
      text = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1d57", ATTRS{idProduct}=="fa60", TAG+="uaccess"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1d57", ATTRS{idProduct}=="fa55", TAG+="uaccess"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1d57", ATTRS{idProduct}=="fa61", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTR{idVendor}=="1d57", ATTR{idProduct}=="fa60", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTR{idVendor}=="1d57", ATTR{idProduct}=="fa55", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTR{idVendor}=="1d57", ATTR{idProduct}=="fa61", TAG+="uaccess"
      '';
    })
  ];
}
