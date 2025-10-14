default:
  just --list

update-dependency:
  sudo nix flake update

build-vm:
  sudo nixos-rebuild switch --flake .#nixos-vm

build-hv:
  sudo nixos-rebuild switch --flake .#nixos-hv

# 强制重新安装引导加载器的 Hyper-V 构建
build-hv-force:
  sudo nixos-rebuild switch --flake .#nixos-hv --install-bootloader

# 诊断引导环境
diagnose-boot:
  echo "=== NixOS 引导诊断 ==="
  echo "1. 当前系统配置："
  readlink /run/current-system
  echo ""
  echo "2. 引导模式检查："
  if [ -d /sys/firmware/efi ]; then echo "UEFI 模式"; else echo "BIOS 模式"; fi
  echo ""
  echo "3. 磁盘分区："
  lsblk
  echo ""
  echo "4. 引导分区："
  df -h | grep -E "(boot|efi)" || echo "未找到专用引导分区"
  echo ""
  echo "5. GRUB 状态："
  if command -v grub-install >/dev/null 2>&1; then echo "GRUB 已安装"; else echo "未找到 GRUB"; fi

# 手动修复引导加载器
fix-boot:
  echo "手动修复引导加载器..."
  sudo nixos-rebuild switch --flake .#nixos-hv
  sudo grub-install /dev/sda
  sudo grub-mkconfig -o /boot/grub/grub.cfg
  echo "引导加载器修复完成！"

# 验证当前配置
verify-config:
  echo "=== 配置验证 ==="
  echo "当前活动配置："
  readlink /run/current-system
  echo ""
  echo "GRUB 文件："
  ls /boot/grub/ 2>/dev/null || echo "未找到 /boot/grub/"
  echo ""
  echo "系统版本："
  nixos-version

# 查看构建日志
show-build-log:
  journalctl -u nixos-rebuild --no-pager -n 50

# 修复 Hyper-V 分辨率
fix-resolution:
  echo "=== 修复 Hyper-V 分辨率 ==="
  echo "1. 重启 X11 服务..."
  sudo systemctl restart display-manager
  echo "2. 检查当前分辨率..."
  xrandr
  echo "3. 设置分辨率为 2560x1440..."
  xrandr --output Virtual-1 --mode 2560x1440 || xrandr --output default --mode 2560x1440 || echo "自动设置失败，请手动调整"
  echo "分辨率修复完成！"

# 检查显示状态
check-display:
  echo "=== 显示状态检查 ==="
  echo "当前分辨率："
  if command -v swaymsg >/dev/null 2>&1; then
    echo "Sway 输出信息："
    swaymsg -t get_outputs
  else
    xrandr | grep -E "\\*|connected"
  fi
  echo ""
  echo "可用分辨率："
  if command -v swaymsg >/dev/null 2>&1; then
    echo "使用 swaymsg 查看输出信息"
  else
    xrandr --query
  fi
  echo ""
  echo "显示驱动模块："
  lsmod | grep -E "(hyperv|fb|drm)"

# Sway 专用分辨率修复
fix-sway-resolution:
  echo "=== 修复 Sway 分辨率 ==="
  echo "1. 检查当前输出..."
  swaymsg -t get_outputs
  echo ""
  echo "2. 设置分辨率为 2560x1440..."
  swaymsg output "*" mode 2560x1440@60Hz
  swaymsg output "*" scale 1
  echo ""
  echo "3. 验证设置..."
  swaymsg -t get_outputs | grep -E "(name|current_mode)"
  echo "分辨率修复完成！"

git-status:
  git status

commit:
  git commit

push:
  git push

pull:
  git pull


