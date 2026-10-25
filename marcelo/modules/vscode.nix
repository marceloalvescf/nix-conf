{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions =
        with pkgs.vscode-extensions;
        [
          anthropic.claude-code
          eamodio.gitlens
          hashicorp.terraform
          jnoortheen.nix-ide
          ms-azuretools.vscode-containers
          ms-python.debugpy
          ms-python.python
          ms-python.vscode-pylance
          ms-vscode-remote.remote-ssh
          redhat.vscode-yaml
          teabyii.ayu
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
        "workbench.preferredLightColorTheme" = "Ayu Light Bordered";
        "workbench.preferredDarkColorTheme" = "Ayu Dark Bordered";
        "workbench.iconTheme" = "ayu";

        "terminal.integrated.profiles.linux" = {
          fish = {
            path = "${pkgs.fish}/bin/fish";
            args = [ "-l" ];
          };
        };
        "terminal.integrated.defaultProfile.linux" = "fish";

        "editor.minimap.enabled" = false;
        "redhat.telemetry.enabled" = false;
        "git.confirmSync" = false;
        "workbench.startupEditor" = "none";
        "explorer.confirmDelete" = false;
        "terminal.integrated.enableMultiLinePasteWarning" = "never";
        "git.autofetch" = true;
        "explorer.confirmDragAndDrop" = false;

        "debug.console.fontSize" = 13;
        "editor.fontSize" = 13;
        "terminal.integrated.fontSize" = 13;

        "editor.largeFileOptimizations" = false;

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.formatterPath" = "nixfmt";

        # 4ops.terraform also claims .tf/.tfvars; pin them to hashicorp.terraform
        # so terraform-ls still activates, leaving .hcl to 4ops for terragrunt.
        "files.associations" = {
          "*.tf" = "terraform";
          "*.tfvars" = "terraform-vars";
        };

        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };

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

        "terminal.external.linuxExec" = "ptyxis";
        "terminal.integrated.stickyScroll.enabled" = false;
        "terminal.integrated.suggest.enabled" = false;
        "claudeCode.preferredLocation" = "panel";
        "gitlens.codeLens.scopes" = "[]";
      };
    };
  };
}
