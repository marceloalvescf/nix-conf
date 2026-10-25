{ lib, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = false;
    settings = {
      format = lib.concatStrings [
        "[](red)"
        "$os"
        "$username"
        "[](bg:orange fg:red)"
        "$directory"
        "[](bg:yellow fg:orange)"
        "$git_branch"
        "$git_status"
        "[](fg:yellow bg:green)"
        "$c"
        "$rust"
        "$golang"
        "$nodejs"
        "$php"
        "$java"
        "$kotlin"
        "$haskell"
        "$python"
        "[](fg:green bg:blue)"
        "$conda"
        "$docker_context"
        "$kubernetes"
        "[](fg:blue bg:purple)"
        "$time"
        "[ ](fg:purple)"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      palette = "ayu_dark";

      palettes.ayu_dark = {
        bg = "#0d1017";
        fg = "#bfbdb6";
        red = "#f07178";
        orange = "#ff8f40";
        yellow = "#ffb454";
        green = "#aad94c";
        blue = "#59c2ff";
        purple = "#d2a6ff";
      };

      os = {
        disabled = false;
        style = "bg:red fg:bg";
        symbols = {
          Windows = "󰍲";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          EndeavourOS = "";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
          Pop = "";
        };
      };

      username = {
        show_always = true;
        style_user = "bg:red fg:bg";
        style_root = "bg:red fg:bg";
        format = "[ $user]($style)";
      };

      directory = {
        style = "bg:orange fg:bg";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          Documents = "󰈙 ";
          Downloads = " ";
          Music = "󰝚 ";
          Pictures = " ";
          Developer = "󰲋 ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:yellow";
        format = "[[ $symbol $branch ](fg:bg bg:yellow)]($style)";
      };

      git_status = {
        style = "bg:yellow";
        format = "[[($all_status$ahead_behind )](fg:bg bg:yellow)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:bg bg:green)]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:bg bg:green)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:bg bg:green)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:bg bg:green)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:bg bg:green)]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:bg bg:green)]($style)";
      };

      kotlin = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:bg bg:green)]($style)";
      };

      haskell = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:bg bg:green)]($style)";
      };

      python = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version)(\(#$virtualenv\)) ](fg:bg bg:green)]($style)";
      };

      docker_context = {
        symbol = "";
        style = "bg:blue";
        format = "[[ $symbol( $context) ](fg:bg bg:blue)]($style)";
      };

      kubernetes = {
        symbol = "󱃾";
        style = "bg:blue";
        format = "[[ $symbol( $context) ](fg:bg bg:blue)]($style)";
        disabled = false;
      };

      conda = {
        symbol = "  ";
        style = "fg:bg bg:blue";
        format = "[$symbol$environment ]($style)";
        ignore_base = false;
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:purple";
        format = "[[  $time ](fg:bg bg:purple)]($style)";
      };

      line_break = {
        disabled = true;
      };

      character = {
        disabled = false;
        success_symbol = "[❯](bold fg:green)";
        error_symbol = "[❯](bold fg:red)";
        vimcmd_symbol = "[❮](bold fg:green)";
        vimcmd_replace_one_symbol = "[❮](bold fg:purple)";
        vimcmd_replace_symbol = "[❮](bold fg:purple)";
        vimcmd_visual_symbol = "[❮](bold fg:yellow)";
      };

      cmd_duration = {
        show_milliseconds = true;
        format = " in $duration ";
        style = "bg:purple";
        disabled = false;
        show_notifications = true;
        min_time_to_notify = 45000;
      };
    };
  };
}
