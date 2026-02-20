{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions =
        with pkgs.vscode-extensions;
        [
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
          eamodio.gitlens
          hashicorp.terraform
          jnoortheen.nix-ide
          ms-azuretools.vscode-containers
          ms-azuretools.vscode-docker
          ms-python.debugpy
          ms-python.python
          ms-vscode-remote.remote-ssh
          redhat.vscode-yaml
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "terraform";
            publisher = "4ops";
            version = "0.2.5";
            sha256 = "sha256-y5LljxK8V9Fir9EoG8g9N735gISrlMg3czN21qF/KjI=";
          }
        ];
      userSettings = {
        "editor.fontFamily" = "JetBrainsMono Nerd Font Mono";
        "debug.console.fontFamily" = "JetBrainsMono Nerd Font Mono";
        "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font Mono";

        "window.autoDetectColorScheme" = true;
        "workbench.preferredLightColorTheme" = "Catppuccin Latte";
        "workbench.preferredDarkColorTheme" = "Catppuccin Mocha";

        "terminal.integrated.profiles.linux" = {
          fish = {
            path = "/etc/profiles/per-user/marcelo/bin/fish";
            args = [ "-l" ];
          };
        };
        "terminal.integrated.defaultProfile.linux" = "fish";

        "security.workspace.trust.untrustedFiles" = "open";
        "editor.minimap.enabled" = false;
        "redhat.telemetry.enabled" = false;
        "git.confirmSync" = false;
        "workbench.startupEditor" = "none";
        "explorer.confirmDelete" = false;
        "terminal.integrated.enableMultiLinePasteWarning" = "never";
        "git.autofetch" = true;
        "explorer.confirmDragAndDrop" = false;

        "debug.console.fontSize" = 14;
        "editor.fontSize" = 14;
        "terminal.integrated.fontSize" = 14;

        "editor.largeFileOptimizations" = false;
        "workbench.iconTheme" = "catppuccin-mocha";

        "[dockercompose]" = {
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2;
          "editor.autoIndent" = "advanced";
          "editor.quickSuggestions" = {
            other = true;
            comments = false;
            strings = true;
          };
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };

        "[github-actions-workflow]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };

        "terminal.external.linuxExec" = "kitty";
        "terminal.integrated.stickyScroll.enabled" = false;
        "terminal.integrated.suggest.enabled" = false;
      };
    };
  };
}
