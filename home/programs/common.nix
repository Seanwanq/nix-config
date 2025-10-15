{
  lib,
  pkgs,
  catppuccin-bat,
  yazi-dracula,
  ...
}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip

    # utils
    ripgrep
    yq-go # https://github.com/mikefarah/yq

    # misc
    libnotify
    wineWowPackages.wayland
    xdg-utils
    graphviz

    # obsidian

    # docker-compose
    # kubectl

    # nodejs
    # nodePackages.npm
    # nodePackages.pnpm
    yarn

    # db related
    # dbeaver-bin
    # mycli
    # pgcli

    stylua
    ruff
    uv
    llvmPackages_21.libcxxClang
    rustup

    trash-cli
    just
  ];

  # 全局 session 变量，对所有应用生效
  home.sessionVariables = {
    PATH = "$HOME/.local/bin:$PATH";
  };

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = "mouse on";
    };

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "catppuccin-mocha";
      };
      themes = {
        # https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-mocha.tmTheme
        catppuccin-mocha = {
          src = catppuccin-bat;
          file = "Catppuccin-mocha.tmTheme";
        };
      };
    };

    btop.enable = true; # replacement of htop/nmon
    eza.enable = true; # A modern replacement for ‘ls’
    jq.enable = true; # A lightweight and flexible command-line JSON processor
    ssh.enable = true;
    aria2.enable = true;

    skim = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files --hidden";
      changeDirWidgetOptions = [
        "--preview 'exa --icons --git --color always -T -L 3 {} | head -200'"
        "--exact"
      ];
    };

    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
        ];
        theme = "fishy";
      };
      autosuggestion = {
          enable = true;
          highlight = "fg=#ff00ff,bg=cyan,bold,underline";
      };
      autocd = false;
      sessionVariables = {
        PATH = "$HOME/.local/bin:$PATH";
      };
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
      
      # yazi.toml 配置
      settings = {
        # 使用新的 [mgr] 替代已弃用的 [manager]
        mgr = {
          show_hidden = false;
          sort_by = "natural";
          sort_dir_first = true;
          linemode = "size_and_mtime";
          show_symlink = true;
          scrolloff = 200;
        };
        preview = {
          wrap = "yes";
          tab_size = 2;
        };
      };
      
      # 应用 dracula flavor
      # 将 flavor 文件链接到 ~/.config/yazi/flavors/
      flavors = {
        dracula = yazi-dracula;
      };
      
      # theme.toml 配置 - 激活 dracula flavor
      theme = {
        flavor = {
          light = "dracula";
          dark = "dracula";
        };
      };
      
      # init.lua 配置 - 自定义 linemode
      initLua = ''
        function Linemode:size_and_mtime()
          local time = math.floor(self._file.cha.mtime or 0)
          if time == 0 then
            time = ""
          elseif os.date("%Y", time) == os.date("%Y") then
            time = os.date("%b %d %H:%M", time)
          else
            time = os.date("%b %d  %Y", time)
          end

          local size = self._file:size()
          return string.format("%s %s", size and ya.readable_size(size) or "-", time)
        end
      '';
    };

  };

  services = {
    syncthing.enable = true;

    # auto mount usb drives
    udiskie.enable = true;
  };
}
