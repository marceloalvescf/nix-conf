{ config, pkgs, ... }:

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

    # home-manager still generates provider settings in initLua; sideloading
    # them through the wrapper keeps nvim/init.lua free for LazyVim.
    sideloadInitLua = true;
  };

  # Out-of-store link so lazy.nvim and LazyVim can rewrite lazy-lock.json and
  # lazyvim.json in place, keeping both versioned in this repo.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/Starscream/nix-conf/marcelo/nvim";
}
