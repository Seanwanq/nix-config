default:
  just --list

# 更新 flake 依赖
update-dependency:
  nix flake update

# 构建并切换 Hyper-V 虚拟机配置
build-hv:
  sudo nixos-rebuild switch --flake .#nixos-hv

# 从 GitHub 拉取最新配置并切换 Hyper-V 虚拟机
update-hv:
  git pull --ff-only
  sudo nixos-rebuild switch --flake .#nixos-hv

# 测试 Hyper-V 虚拟机配置（不应用）
check-hv:
  sudo nixos-rebuild dry-run --flake .#nixos-hv

# 构建并切换 NixOS-WSL 配置
build-wsl:
  sudo nixos-rebuild switch --flake .#nixos-wsl

# 从 GitHub 拉取最新配置并切换 NixOS-WSL
update-wsl:
  git pull --ff-only
  sudo nixos-rebuild switch --flake .#nixos-wsl

# 测试 NixOS-WSL 配置（不应用）
check-wsl:
  sudo nixos-rebuild dry-run --flake .#nixos-wsl

# 生成 NixOS-WSL 安装包 nixos.wsl（在任意 NixOS 上运行，例如 nixos-hv）
wsl-tarball:
  sudo nix run .#nixosConfigurations.nixos-wsl.config.system.build.tarballBuilder

# 应用 MacBook Pro 的 nix-darwin 配置。
# 首次运行前请先执行 bootstrap：
# nix run github:nix-community/nix-darwin -- switch --flake .#Siyuans-MacBook-Pro
build-mbp:
  # Work around current Homebrew cask API regression during darwin activation.
  sudo env HOMEBREW_NO_INSTALL_FROM_API=1 darwin-rebuild switch --flake .#Siyuans-MacBook-Pro --no-write-lock-file

# 检查 MacBook Pro 配置（不应用）
check-mbp:
  darwin-rebuild build --flake .#Siyuans-MacBook-Pro --no-write-lock-file

# 清理 Nix 存储（释放空间）
gc:
  nix-collect-garbage -d

gc-30d:
  sudo nix-collect-garbage --delete-older-than 30d
