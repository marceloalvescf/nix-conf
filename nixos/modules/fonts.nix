{ pkgs, ... }:

let
  nf = pkgs.nerd-fonts;
in

{
  # Install fonts system-wide
  fonts.packages = with pkgs; [
    dejavu_fonts
    ibm-plex
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    ubuntu-sans
    ubuntu-sans-mono

    # Nerd fonts
    nf.code-new-roman
    nf.commit-mono
    nf.fantasque-sans-mono
    nf.jetbrains-mono
  ];

  # Set default font families for the entire system
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "IBM Plex Serif" ];
        sansSerif = [ "IBM Plex Sans" ];
        monospace = [ "IBM Plex Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
