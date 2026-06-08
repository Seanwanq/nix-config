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
  nix shell github:nix-community/home-manager/release-26.05#home-manager -c home-manager switch --flake .#sean@wsl

build-wsl-fresh:
  mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
  nix shell github:nix-community/home-manager/release-26.05#home-manager -c home-manager switch --flake .#sean@wsl

# 检查 Home Manager 配置（不应用）
check-wsl:
  nix shell github:nix-community/home-manager/release-26.05#home-manager -c home-manager build --flake .#sean@wsl

# 应用 MacBook Pro 的 nix-darwin 配置。
# 首次运行前请先执行 bootstrap：
# nix run github:nix-community/nix-darwin -- switch --flake .#Siyuans-MacBook-Pro
build-mbp:
  HOMEBREW_NO_AUTO_UPDATE=1 brew tap homebrew/cask
  # Work around current Homebrew cask API regression during darwin activation.
  sudo env HOMEBREW_NO_INSTALL_FROM_API=1 darwin-rebuild switch --flake .#Siyuans-MacBook-Pro --no-write-lock-file

# 检查 MacBook Pro 配置（不应用）
check-mbp:
  darwin-rebuild build --flake .#Siyuans-MacBook-Pro --no-write-lock-file

# 清理 Nix 存储（释放空间）
gc:
  nix-collect-garbage -d

