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
}
