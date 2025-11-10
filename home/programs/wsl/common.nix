{
  lib,
  pkgs,
  nixpkgs-unstable,
  catppuccin-bat,
  inputs,
  ...
}:
let
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  home.packages = with pkgs; [
    wget # 下载工具
    curl # 数据传输工具
    git # 版本控制
    sysstat # 系统统计工具
    lm_sensors # 硬件监控
    fastfetch # 系统信息显示
    gnumake # Make 工具
    cmake # 编译系统
    gcc14 # C/C++ 编译器
    gdb # 调试器
    libgcc # GCC 运行库
    ninja # 构建系统
    icu # Unicode 库

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

    yarn

    stylua
    ruff
    uv
    # llvmPackages_21.libcxxClang  # 与 gcc14 冲突，建议使用 gcc
    # lldb_21
    rustup

    trash-cli
    just

    # GitHub flake packages
    inputs.tuios.packages.${pkgs.system}.tuios

    # Unstable packages
    pkgs-unstable.typst

    jdk24
    pkgs-unstable.gradle_8
    pkgs-unstable.kotlin

    pkgs-unstable.zig

    nasm

    pkgs-unstable.julia
  ];

  # 全局 session 变量，对所有应用生效
  home.sessionVariables = {
    PATH = "$DOTNET_ROOT:$DOTNET_ROOT/tools:$HOME/.local/bin:$PATH";
    LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.libgcc}/lib";
    DOTNET_ROOT = "$HOME/.dotnet";
    JAVA_HOME = "${pkgs.jdk24}";
  };

  programs = {
    # tmux = {
    #   enable = true;
    #   clock24 = true;
    #   keyMode = "vi";
    #   extraConfig = "mouse on";
    # };

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        # theme = "catppuccin-mocha";
      };
      # themes = {
      #   # https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-mocha.tmTheme
      #   catppuccin-mocha = {
      #     src = catppuccin-bat;
      #     file = "Catppuccin-mocha.tmTheme";
      #   };
      # };
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


  services = {
  };
}
