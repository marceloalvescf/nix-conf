{ ... }:

{
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
  };
}
