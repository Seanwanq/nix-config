{
  pkgs,
  config,
  ...
}: {
  # 启用 neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;  # 设置为默认编辑器
    viAlias = true;        # 创建 vi 别名
    vimAlias = true;       # 创建 vim 别名
  };

  # 链接 nvim 配置文件夹到 ~/.config/nvim
  home.file.".config/nvim" = {
    source = ./nvim-config;
    recursive = true;  # 递归链接整个目录
  };
}