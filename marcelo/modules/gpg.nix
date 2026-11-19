{ ... }:

{
  programs.gpg = {
    enable = true;

    # Home Manager already defaults to most of drduh's YubiKey-Guide gpg.conf;
    # these are the remaining options. throw-keyids is left out because it
    # breaks tools that look up the recipient key.
    settings = {
      no-greeting = true;
      require-secmem = true;
      armor = true;
    };

    # Reach the YubiKey through pcscd instead of scdaemon's built-in CCID
    # driver, so gpg and ykman can share the card. Selecting the unused PIV
    # applet drops the OpenPGP PIN unlock, so scdaemon skips it.
    scdaemonSettings = {
      disable-ccid = true;
      pcsc-shared = true;
      disable-application = "piv";
    };
  };

  # The YubiKey authentication key is offered to SSH automatically while the
  # card is inserted. The desktop module sets the pinentry.
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
}
