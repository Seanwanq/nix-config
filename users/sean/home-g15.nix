{ config, pkgs, ... }:
{
  ##################################################################################################################
  #
  # Sean's Home Manager Configuration for Dell G15
  #
  ##################################################################################################################

  imports = [
    ../../home/core.nix

    ../../home/fcitx5 # 启用 fcitx5 输入法配置
    # ../../home/i3        # 在 Hyper-V 中不使用 i3
    ../../home/niri # 启用 niri
    ../../home/nvim
    # ../../home/sway        # Hyper-V 中使用 sway
    ../../home/programs
    ../../home/rofi
    ../../home/shell
    ../../home/rclone
  ];

  programs.git = {
    settings.user = {
      email = "seanwang313@outlook.com";
      name = "Seanwanq";
    };
  };

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
}
