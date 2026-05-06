{ pkgs, ... }:
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
  ];

  programs = {
    bat = {
      enable = true;
      config.pager = "less -FR";
    };

    eza.enable = true;
    jq.enable = true;
  };
}
