{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  # 为 VSCode 设置 Electron 标志以支持 Wayland IME
  # 这是解决 Fcitx5 在 Electron 应用中输入法问题的关键
  home.file.".config/code-flags.conf".text = ''
    --enable-wayland-ime
    --enable-features=UseOzonePlatform,WaylandWindowDecorations
    --ozone-platform=wayland
  '';
}
