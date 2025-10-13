{pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    
    # 基本设置
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    
    # 用户设置
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
    };
  };
}
