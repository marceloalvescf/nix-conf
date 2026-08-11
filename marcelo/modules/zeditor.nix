{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;

    mutableUserSettings = false;

    extraPackages = with pkgs; [
      basedpyright
      nil
      nixfmt
      ruff
    ];

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
      project_panel = {
        dock = "left";
      };

      outline_panel = {
        dock = "left";
      };

      collaboration_panel = {
        dock = "left";
      };

      git_panel = {
        dock = "left";
      };

      agent = {
        dock = "right";
        default_profile = "ask";
      };

      agent_servers = {
        codex-acp = {
          type = "registry";
        };
        claude-acp = {
          type = "registry";
          default_config_options.model = "opus";
        };
      };

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
        Nix = {
          language_servers = [
            "nil"
            "!nixd"
          ];
          format_on_save = "on";
        };

        Python = {
          language_servers = [
            "basedpyright"
            "ruff"
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
