{
  inputs,
  pkgs,
  ...
}:

let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  # Three fixes on top of the llm-agents derivation:
  #
  # 1. ANGLE dlopen()s the native "libEGL.so.1" by soname to reach the real
  #    GPU driver. NixOS has no ldconfig cache, so without the driver dir on
  #    the library path that lookup fails, GPU init aborts, and Chromium falls
  #    back to software rendering — making the UI sluggish. The upstream
  #    wrapper only puts the app dir on LD_LIBRARY_PATH, so add the impure
  #    system driver path on top.
  #
  # 2. GNOME resolves Icon= against its theme cache, which a home-manager
  #    profile install never regenerates; point at the absolute store PNG so
  #    the launcher icon renders without a cache lookup.
  #
  # 3. The Electron app reports "com.anthropic.Claude" as its X11 WM_CLASS /
  #    Wayland app_id, but upstream declares StartupWMClass=claude-desktop.
  #    GNOME then fails to map the window onto the launcher and shows a
  #    separate, generic dash entry named after the raw app id.
  claude-desktop = llmAgents.claude-desktop.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      wrapProgram "$out/bin/claude-desktop" \
        --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"

      substituteInPlace "$out/share/applications/claude-desktop.desktop" \
        --replace-fail 'Icon=claude-desktop' \
          "Icon=$out/share/icons/hicolor/256x256/apps/claude-desktop.png" \
        --replace-fail 'StartupWMClass=claude-desktop' \
          'StartupWMClass=com.anthropic.Claude'
    '';
  });

in
{
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
      claude-desktop
    ];
}
