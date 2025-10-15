{
  yazi-dracula,
  yazi-plugins,
  ...
}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    
    # yazi.toml 配置
    settings = {
      # 使用新的 [mgr] 替代已弃用的 [manager]
      mgr = {
        show_hidden = false;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size_and_mtime";
        show_symlink = true;
        scrolloff = 200;
      };
      preview = {
        wrap = "yes";
        tab_size = 2;
      };
    };
    
    # 应用 dracula flavor
    # 将 flavor 文件链接到 ~/.config/yazi/flavors/
    flavors = {
      dracula = yazi-dracula;
    };
    
    # yazi plugins - 从官方插件仓库安装
    plugins = {
      full-border = "${yazi-plugins}/full-border.yazi";
      # 以后可以添加更多插件，例如:
      # smart-enter = "${yazi-plugins}/smart-enter.yazi";
      # chmod = "${yazi-plugins}/chmod.yazi";
    };
    
    # theme.toml 配置 - 激活 dracula flavor
    theme = {
      flavor = {
        light = "dracula";
        dark = "dracula";
      };
    };
    
    # init.lua 配置 - 自定义 linemode 和启用插件
    initLua = ''
      -- 自定义 linemode: 显示文件大小和修改时间
      function Linemode:size_and_mtime()
        local time = math.floor(self._file.cha.mtime or 0)
        if time == 0 then
          time = ""
        elseif os.date("%Y", time) == os.date("%Y") then
          time = os.date("%b %d %H:%M", time)
        else
          time = os.date("%b %d  %Y", time)
        end

        local size = self._file:size()
        return string.format("%s %s", size and ya.readable_size(size) or "-", time)
      end
      
      -- 启用 full-border 插件
      require("full-border"):setup()
    '';
  };
}
