{ pkgs, lib, nixpkgs-unstable, ... }:
let
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  home.packages = with pkgs; [
    # 基础工具
    fd
    ripgrep
    jq
    just
    gh
    curl
    wget
    btop

    # 编辑器（macOS 上由 Homebrew 提供）
    neovim
    helix

    # Nix 工具
    alejandra
    deadnix
    statix

    # 归档
    zip
    unzip
    p7zip

    # C/C++ 工具链
    gcc
    gdb
    gnumake
    cmake
    ninja
    clang-tools

    rustup
    fastfetch

    uv
    pixi
    bun
    fnm

    pkgs-unstable.typst
    pkgs-unstable.zig
    pkgs-unstable.dotnet-sdk_10
    pkgs-unstable.dioxus-cli
    pkgs-unstable.lldb
    (lib.hiPrio pkgs-unstable.rust-analyzer)

    pkgs-unstable.pprof
  ];

  programs = {
    bat = {
      enable = true;
      config.pager = "less -FR";
    };

    eza.enable = true;
    jq.enable = true;

    yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "yy";

      settings = {
        mgr = {
          show_hidden = true;
          sort_by = "natural";
          sort_dir_first = true;
        };
        preview = {
          tab_size = 2;
        };
      };
    };
  };
}
