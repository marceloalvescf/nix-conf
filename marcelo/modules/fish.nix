{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      mcfly init fish | source
      pyenv init - fish | source
      zoxide init fish | source
    '';

    shellAliases = {
      "ls" = "eza --color=auto --group-directories-first";
      "ll" = "ls -l";
      "la" = "ls -a";
      "htop" = "htop -d 10";
      "dmesg" = "sudo dmesg --color=always -T";
      "meuip" = "curl -fsSL --ipv4 ifconfig.me";
      "aria2c" = "aria2c -x 8 -s 8";
      "vim" = "nvim";
      "vi" = "nvim";
      "k" = "kubectl";
      "kx" = "kubectx";
      "cd" = "z";
      "cleandocker" = "docker system prune -a -f";
      "gb" = "git branch --show-current";
      "gck" = "git checkout";
      "gcm" = "git commit";
      "gps" = "git push";
      "reload_kitty" = "kill -SIGUSR1 $KITTY_PID";
    };

    functions = {
      genpasswd = "LC_ALL=C tr -dc 'A-Za-z0-9_!@#$%^&*()-_=+' </dev/random | head -c 32 | xargs | tr -d '\n'";
    };
  };

  programs.zoxide.enable = true;

  home.packages = with pkgs; [
    fishPlugins.tide
  ];
}
