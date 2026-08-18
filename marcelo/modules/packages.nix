{
  inputs,
  pkgs,
  ...
}:

let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

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
      # IA related packages from llm-agents overlay
      llmAgents.chatgpt
      llmAgents.claude-desktop
    ];
}
