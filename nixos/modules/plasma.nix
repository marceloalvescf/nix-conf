{ pkgs, ... }:

{
  services = {
    # Disable X11
    xserver.enable = false;

    # Replaced sddm with greetd (lighter, more reliable under Wayland-only)
    displayManager.sddm.enable = false;

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd startplasma-wayland";
        };
      };
    };

    # Install Plasma 6
    desktopManager.plasma6.enable = true;
  };

  environment.systemPackages = with pkgs.kdePackages; [
    kamoso
    kcalc
  ];

  # Remove unnecessary Plasma packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    dolphin-plugins
    elisa
    khelpcenter
    konsole
    plasma-browser-integration
  ];

  # greetd runs on a VT, so pam_kwallet5 sees PAM_TTY=tty1 and skips its session
  # hook ("not a graphical session"), leaving kwalletd6 to prompt. force_run
  # bypasses that check so the login password reaches the wallet.
  security.pam.services.login.kwallet.forceRun = true;
}
