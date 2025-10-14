{
  pkgs,
  config,
  ...
}: let
  rofi-power-menu = pkgs.writeShellScriptBin "rofi-power-menu" ''
    #!/usr/bin/env bash
    
    # Rofi 电源管理菜单
    
    # 选项
    shutdown="🔴 关机"
    reboot="🔄 重启"
    logout="🚪 注销"
    suspend="💤 挂起"
    lock="🔒 锁屏"
    cancel="❌ 取消"
    
    # Rofi CMD
    rofi_cmd() {
        rofi -dmenu \
            -p "电源选项" \
            -mesg "选择一个电源操作" \
            -theme-str 'window {width: 350px;}'
    }
    
    # 确认对话框
    confirm_cmd() {
        rofi -dmenu \
            -p "确认" \
            -mesg "你确定要执行这个操作吗？" \
            -theme-str 'window {width: 300px;}'
    }
    
    # 变量传递给 rofi dmenu
    run_rofi() {
        echo -e "$lock\n$logout\n$suspend\n$reboot\n$shutdown\n$cancel" | rofi_cmd
    }
    
    # 执行命令
    run_cmd() {
        if [[ $1 == '--shutdown' ]]; then
            systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
            systemctl reboot
        elif [[ $1 == '--suspend' ]]; then
            systemctl suspend
        elif [[ $1 == '--logout' ]]; then
            swaymsg exit
        elif [[ $1 == '--lock' ]]; then
            swaylock -f
        fi
    }
    
    # 主逻辑
    chosen="$(run_rofi)"
    case ''${chosen} in
        $shutdown)
            ans=$(echo -e "是\n否" | confirm_cmd)
            if [[ $ans == "是" ]]; then
                run_cmd --shutdown
            fi
            ;;
        $reboot)
            ans=$(echo -e "是\n否" | confirm_cmd)
            if [[ $ans == "是" ]]; then
                run_cmd --reboot
            fi
            ;;
        $logout)
            ans=$(echo -e "是\n否" | confirm_cmd)
            if [[ $ans == "是" ]]; then
                run_cmd --logout
            fi
            ;;
        $suspend)
            run_cmd --suspend
            ;;
        $lock)
            run_cmd --lock
            ;;
    esac
  '';
in {
  # Rofi 配置
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;  # 使用 Wayland 版本的 rofi
    terminal = "foot";
    theme = "gruvbox-dark-hard";
  };

  # 将电源菜单脚本添加到 packages，这样会自动在 PATH 中
  home.packages = [
    rofi-power-menu
  ];
}