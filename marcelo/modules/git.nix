{ pkgs, ... }:

{
  home.packages = with pkgs; [ git-filter-repo ];
  programs.git = {
    enable = true;

    # Default identity
    settings = {
      user = {
        name = "Marcelo Alves";
        email = "alvesmarcelocf@proton.me";
      };
      pull.rebase = true;
    };

    # YubiKey OpenPGP signature subkey; "!" pins this exact subkey
    signing = {
      format = "openpgp";
      key = "7B7558ABEB707090683AA77C90422C93F883108A!";
      signByDefault = true;
    };
  };
}
