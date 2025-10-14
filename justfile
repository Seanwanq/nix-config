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

git-status:
  git status

commit:
  git commit

push:
  git push

pull:
  git pull


