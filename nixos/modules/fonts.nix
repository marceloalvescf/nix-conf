{ inputs,
  pkgs, 
  ... 
}:

let
  nf = pkgs.nerd-fonts;
  apple = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system};
in

{
  # Install fonts system-wide
  fonts.packages = with pkgs; [
    apple.sf-pro
    apple.sf-mono
    apple.ny
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    roboto
    roboto-mono
    roboto-serif

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
        serif = [ "New York" ];
        sansSerif = [ "SF Pro Text" ];
        monospace = [ "SF Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
