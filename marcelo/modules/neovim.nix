{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    extraPackages = with pkgs; [
      lua-language-server
      stylua
      ripgrep
      gcc
    ];

    sideloadInitLua = true;
  };
}
