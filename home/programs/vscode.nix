{pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles = {
      default = {
        userSettings = {
          # 基本编辑器设置
          "editor.fontSize" = 14;
          "editor.fontFamily" = "JetBrainsMono Nerd Font";
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
      
          # 主题
          "workbench.colorTheme" = "Default Dark+";
      
          # 终端设置
          "terminal.integrated.fontSize" = 14;
          "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
      
          # 文件设置
          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 1000;

          # 中文输入法兼容性设置 (解决 Fcitx5 在 Electron 应用中拼音字母重复显示的问题)
          # 启用 Wayland IME 支持
          "window.titleBarStyle" = "custom";
        };
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
      };
    };
    
  };

  # 为 VSCode 设置 Electron 标志以支持 Wayland IME
  # 这是解决 Fcitx5 在 Electron 应用中输入法问题的关键
  home.file.".config/code-flags.conf".text = ''
    --enable-wayland-ime
    --enable-features=UseOzonePlatform,WaylandWindowDecorations
    --ozone-platform=wayland
  '';
}
