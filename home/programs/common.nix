{
  lib,
  pkgs,
  nixpkgs-unstable,
  catppuccin-bat,
  ...
}: let
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in {
  home.packages = with pkgs;     
  [ 
    btop # replacement of htop/nmon
    eza # A modern replacement for 'ls'
    jq # A lightweight and flexible command-line JSON processor
    

    
    aria2
    
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

    zotero
    
    # Unstable packages
    pkgs-unstable.typst

    cliphist
    
    libreoffice-qt6-fresh

    papers
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
        theme = "robbyrussell";
      };
      autosuggestion = {
          enable = true;
          highlight = "fg=#8080c6,bold,underline";
      };
      autocd = true;
      sessionVariables = {
        PATH = "$HOME/.local/bin:$PATH";
      };
      
    };


  };

  # # 1Password SSH agent
  # systemd.user.services."1password-ssh-agent" = {
  #   Unit = {
  #     Description = "1Password SSH agent";
  #   };
  #   Service = {
  #     # The socket path is hard-coded in the 1Password app.
  #     ExecStart = "${pkgs._1password-gui}/bin/op-ssh-agent --socket-path %h/.1password/agent.sock";
  #   };
  #   Install = {
  #     WantedBy = [ "default.target" ];
  #   };
  # };

  services = {
    syncthing.enable = true;

    # auto mount usb drives
    udiskie.enable = true;
  };
}
