{
  inputs,
  pkgs,
  ...
}:

let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  chatgpt = llmAgents.chatgpt;

  # Upstream now ships claude-desktop as a buildFHSEnv/bwrap wrapper, whose
  # builder sets `buildCommand`. stdenv's genericBuild returns right after
  # evaluating it, so fixupPhase never runs and any postFixup added via
  # overrideAttrs is silently dropped. $out/share is also a symlink into the
  # unwrapped package, so patching the desktop entry in the derivation is out.
  # Ship our own entry instead — it shadows the package one by desktop file ID
  # (XDG_DATA_HOME wins over the profile), and survives upstream repackaging.
  claude-desktop = llmAgents.claude-desktop;

in
{
  # The Electron app reports "com.anthropic.Claude" as its Wayland app_id /
  # X11 WM_CLASS, while upstream installs claude-desktop.desktop declaring
  # StartupWMClass=claude-desktop. GNOME matches windows to entries by desktop
  # file ID first, then StartupWMClass; both miss, so the window gets its own
  # generic dash entry labelled with the raw app id. Publish the entry under
  # the app id, declare the matching StartupWMClass, and hide the upstream one.
  #
  # Two more fixes folded into the entry:
  #
  # 1. ANGLE dlopen()s the native "libEGL.so.1" by soname to reach the real GPU
  #    driver. NixOS has no ldconfig cache and the FHS root ships no GL libs,
  #    so that lookup fails, GPU init aborts, and Chromium falls back to
  #    software rendering. bwrap inherits the environment and the inner wrapper
  #    only prefixes LD_LIBRARY_PATH, so exporting the driver dir here reaches
  #    the app.
  #
  # 2. GNOME resolves Icon= against its theme cache, which a home-manager
  #    profile install never regenerates; point at the absolute store PNG.
  xdg.desktopEntries = {
    "com.anthropic.Claude" = {
      name = "Claude";
      genericName = "AI Assistant";
      comment = "Desktop application for Claude.ai";
      exec = "env LD_LIBRARY_PATH=/run/opengl-driver/lib claude-desktop %U";
      icon = "${claude-desktop}/share/icons/hicolor/256x256/apps/claude-desktop.png";
      categories = [
        "Utility"
        "Development"
      ];
      mimeType = [ "x-scheme-handler/claude" ];
      startupNotify = true;
      settings = {
        Keywords = "AI;Chat;Assistant;Claude;Code;LLM";
        SingleMainWindow = "true";
        StartupWMClass = "com.anthropic.Claude";
      };
      actions = {
        NewChat = {
          name = "New chat";
          exec = "claude-desktop claude://claude.ai/new";
        };
        NewCode = {
          name = "New Claude Code session";
          exec = "claude-desktop claude://code/new";
        };
      };
    };

    claude-desktop = {
      name = "Claude";
      exec = "claude-desktop %U";
      noDisplay = true;
    };
  };

  home.packages =
    with pkgs;
    [
      age
      amdgpu_top
      ansible
      arch-install-scripts
      aria2
      bisq2
      bruno
      bun
      cdrtools
      docker-compose
      eza
      fastfetch
      gh
      git
      htop
      jq
      libxslt
      mcfly
      nil
      nixd
      nixfmt
      nodejs
      nvd
      pciutils
      pyenv
      sops
      spotify
      ssh-to-age
      telegram-desktop
      terraform
      virt-manager
      vlc
      wget
      wl-clipboard
    ]
    ++ [
      # AI related packages from llm-agents overlay
      chatgpt
      claude-desktop
    ];
}
