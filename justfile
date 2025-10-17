default:
  just --list

update-dependency:
  sudo nix flake update

build-vm:
  sudo nixos-rebuild switch --flake .#nixos-vm

# 强制重新安装引导加载器的 Hyper-V 构建
build-hv:
  sudo nixos-rebuild switch --flake .#nixos-hv --install-bootloader

build-g15:
  sudo nixos-rebuild switch --flake .#dell-g15

