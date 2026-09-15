{ pkgs, ... }:

let
  # OpenRGB 1.0 only loads plugins that ship Qt JSON metadata (OpenRGBPluginAPIVersion, Id).
  # nixpkgs still packages the 1.0rc2 plugin tags, which predate that metadata, so the
  # PluginManager skips them ("does not have a MetaData field"). Pin to the 1.0 tags until
  # nixpkgs bumps them.
  release10 =
    hash: plugin:
    plugin.overrideAttrs (old: {
      version = "1.0";
      src = old.src.override {
        tag = "release_1.0";
        inherit hash;
      };
    });

  openrgb = pkgs.openrgb.withPlugins [
    (release10 "sha256-+LUP/KVKU7taHIOd274dbcaq/uljACTj/y3TUoaf3iM=" pkgs.openrgb-plugin-effects)
    (release10 "sha256-aqcx3E3t7WEvOPtS7nfvn9jUURE5MhRcL6+HrkZIY6o=" pkgs.openrgb-plugin-hardwaresync)
  ];
in
{
  services.hardware.openrgb = {
    enable = true;
    package = openrgb;
    motherboard = "amd";
  };

  environment.systemPackages = [ openrgb ];
}
