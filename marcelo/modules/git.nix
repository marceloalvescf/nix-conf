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

    # Primary key; gpg signs with its valid signing subkey on the YubiKey
    signing = {
      format = "openpgp";
      key = "EDF8805691FAC1B3AD0A5210A3AEA13F40407F89";
      signByDefault = true;
    };
  };
}
