{ ... }:

{
  # Hardware related settings
  hardware = {
    enableAllFirmware = true;
    i2c.enable = true; # Enable I2C devices

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    graphics.enable = true;
  };
}
