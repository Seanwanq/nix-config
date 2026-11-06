## 结构

| 目录 | 用途 |
|---|---|
| `home/darwin` | macOS 的 Home Manager 配置 |
| `home/linux` | Linux 的 Home Manager 配置（虚拟机与 WSL 共用） |
| `modules/nixos.nix` | NixOS 基础系统配置（用户、Nix、nix-ld） |
| `hosts/nixos-hv` | Hyper-V 虚拟机（无图形界面，SSH） |
| `hosts/nixos-wsl` | WSL2（NixOS-WSL，图形程序走 WSLg + GPU） |
| `hosts/macbook` | MacBook Pro（nix-darwin） |

## WSL2（nixos-wsl）

在任意一台 NixOS 上（例如 nixos-hv）生成安装包，用户 `sean` 已预设好：

```bash
just wsl-tarball   # 生成 ./nixos.wsl
```

拷到 Windows 后（需要 WSL ≥ 2.4.4）：

```powershell
wsl --install --from-file nixos.wsl --name NixOS
wsl -d NixOS
```

进入后克隆仓库并更新：`git clone https://github.com/Seanwanq/nix-config.git ~/nix-config`，之后 `just update-wsl`。

## Hyper-V 虚拟机（nixos-hv）

虚拟机：第 2 代、关闭 Secure Boot，从 NixOS minimal ISO 启动。在 live 环境中（`sudo -i`）：

```bash
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MB 1GB
parted /dev/sda -- set 1 esp on
parted /dev/sda -- mkpart root ext4 1GB 100%
mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 -L nixos /dev/sda2
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot && mount -o umask=077 /dev/disk/by-label/boot /mnt/boot

nixos-install --flake /path/to/nix-config#nixos-hv
nixos-enter --root /mnt -c 'passwd sean'
```

卷标 `boot` / `nixos` 必须与 `hosts/nixos-hv/hardware-configuration.nix` 一致。之后更新：`just build-hv`。

## macOS (MacBook Pro) 快速开始

先启用 flakes（如果你还没做过）：

`mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf`

应用 Mac 的 Home Manager 配置：

`nix shell github:nix-community/home-manager/release-26.05#home-manager -c home-manager switch --flake .#siyuan@mbp`

也可以用 `just`：

`just build-mbp`

如果 Homebrew cask 在 API 模式下报错（例如 `undefined method 'to_sym' for nil`），
`build-mbp` 已内置 `HOMEBREW_NO_INSTALL_FROM_API=1` 规避该问题。

为避免 `darwin-rebuild` 每次触发 Homebrew 自动更新导致耗时波动，
当前配置已关闭激活阶段的 Homebrew auto-update。

另外，`build-mbp` 与 `check-mbp` 已加 `--no-write-lock-file`，避免常规构建过程中改写 `flake.lock`。

首次切换到 non-API 模式时，Homebrew 可能会一次性 clone `homebrew/core`（体积较大，耗时较久）；
该步骤完成后后续通常不会重复。

## 1Password SSH agent notes

If `ssh -T git@github.com` prints `sign_and_send_pubkey: signing failed ... agent refused operation`, 1Password is waiting for you to authorize the request. Unlock 1Password, open the **GitHub 2025** SSH key item, and under **Applications & Hosts** (Advanced) add:

1. Applications: `/run/current-system/sw/bin/ssh` and `/run/current-system/sw/bin/git`.
2. Hosts: `github.com` (and `ssh.github.com` if you use that port).
3. Click **Always allow** so future Git connections succeed without a prompt.

Retry `ssh -T git@github.com`. You should see GitHub's greeting once the key is allowed. The same settings let commit signing with `op-ssh-sign` work reliably on NixOS.