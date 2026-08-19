{
  inputs,
  pkgs,
  ...
}:

let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  # ANGLE dlopen()s the native "libEGL.so.1" by soname to reach the real GPU
  # driver. NixOS has no ldconfig cache, so without the driver dir on the
  # library path that lookup fails, GPU init aborts, and Chromium falls back
  # to software rendering — making the UI sluggish. The llm-agents wrappers
  # only put the app dir on LD_LIBRARY_PATH, so add the impure system driver
  # path on top.
  withGpuDriver =
    pkg:
    pkg.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        wrapProgram "$out/bin/${pkg.meta.mainProgram}" \
          --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
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
      (withGpuDriver llmAgents.claude-desktop)
    ];
}
