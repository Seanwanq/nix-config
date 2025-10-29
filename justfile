default:
  just --list

# 更新 flake 依赖
update-dependency:
  nix flake update

# 构建并切换 Dell G15 配置
build-g15:
  sudo nixos-rebuild switch --flake .#dell-g15

# 测试 Dell G15 配置（不应用）
check-g15:
  sudo nixos-rebuild dry-run --flake .#dell-g15

# 更新 WSL 用户配置
build-wsl:
  nix shell github:nix-community/home-manager/release-25.05#home-manager -c home-manager switch --flake .#sean@wsl

# 检查 Home Manager 配置（不应用）
check-wsl:
  nix shell github:nix-community/home-manager/release-25.05#home-manager -c home-manager build --flake .#sean@wsl

# 清理 Nix 存储（释放空间）
gc:
  nix-collect-garbage -d

