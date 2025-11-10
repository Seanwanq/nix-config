{ config, pkgs, inputs, ... }:
{
  ##################################################################################################################
  #
  # Sean's Home Manager Configuration for WSL
  #
  ##################################################################################################################

  imports = [
    ../../home/core.nix

    ../../home/nvim
    ../../home/programs/wsl
    ../../home/shell/wsl
  ];

  # ============================================================================
  # 用户信息和基本配置
  # ============================================================================

  # 设置默认 shell 为 zsh
  home.shellAliases = {
    # 下面在 home/shell/wsl/default.nix 中定义
  };

  programs.git = {
    userName = "Seanwanq";
    userEmail = "seanwang313@outlook.com";
  };

  # ============================================================================
  # dotnet SDK 配置
  # ============================================================================

  home.activation.dotnet = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    DOTNET_ROOT="$HOME/.dotnet"
    DOTNET_FILE="$HOME/dotnet-x64.tar.gz"
    if [ ! -d "$DOTNET_ROOT" ]; then
      echo "Downloading dotnet SDK..."
      ${pkgs.curl}/bin/curl -L -o "$DOTNET_FILE" "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.306/dotnet-sdk-9.0.306-linux-x64.tar.gz"
      mkdir -p "$DOTNET_ROOT"
      PATH="${pkgs.gzip}/bin:$PATH" ${pkgs.gnutar}/bin/tar zxf "$DOTNET_FILE" -C "$DOTNET_ROOT"
      rm -f "$DOTNET_FILE"
    fi
  '';

  # ============================================================================
  # Home Manager 设置
  # ============================================================================

  home.stateVersion = "25.05"; # 与 NixOS 版本一致
}

