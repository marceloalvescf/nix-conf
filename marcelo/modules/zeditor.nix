{ ... }:

{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "catppuccin"
      "catppuccin-icons"
      "dockerfile"
      "git-firefly"
      "latex"
      "log"
      "nix"
      "terraform"
      "toml"
    ];

    userSettings = {
      auto_indent = "none";

      theme = {
        mode = "system";
        dark = "Catppuccin Mocha";
        light = "Catppuccin Latte";
      };

      icon_theme = {
        mode = "system";
        dark = "Catppuccin Mocha";
        light = "Catppuccin Latte";
      };

      auto_update = false;

      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";
        env = {
          TERM = "alacritty";
        };
        font_family = "JetBrainsMono Nerd Font Mono";
        font_size = 13;
        line_height = "standard";
        shell = {
          program = "fish";
        };
      };

      ui_font_size = 16;
      buffer_font_size = 13;
      buffer_font_family = "JetBrainsMono Nerd Font Mono";
      soft_wrap = "editor_width";

      lsp = {
        nil = {
          initialization_options = {
            formatting = {
              command = [ "nixfmt" ];
            };
          };
        };

        basedpyright = {
          settings = {
            "basedpyright.analysis" = {
              diagnosticMode = "workspace"; # analyze all files, not just open ones
              typeCheckingMode = "standard"; # matches pyright default
              inlayHints = {
                callArgumentNames = false;
              };
            };
          };
        };
      };

      languages = {
        Python = {
          language_servers = [
            "basedpyright"
            "ruff"
            "!pyright"
            "!pylsp"
            "!ty"
            "!pyrefly"
          ];
          code_actions_on_format = {
            "source.organizeImports.ruff" = true;
          };
          formatter = {
            language_server = {
              name = "ruff";
            };
          };
          format_on_save = "on";
        };
      };
    };
  };
}
