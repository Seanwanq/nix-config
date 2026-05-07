{ pkgs, lib, nixpkgs-unstable, ... }:
let
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.system;
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

    # Nix 工具
    alejandra
    deadnix
    statix

    # 归档
    zip
    unzip
    p7zip

    openconnect

    rustup
    fastfetch

    uv
    pixi
    bun
    fnm
    cmake

    pkgs-unstable.typst

    helix
    emacs
    pkgs-unstable.dbeaver-bin
    pkgs-unstable.bruno
    pkgs-unstable.zotero

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
