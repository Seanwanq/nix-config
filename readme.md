`sudo nixos-rebuild switch --flake .#nixos-vm`

## macOS (MacBook Pro) 快速开始

先启用 flakes（如果你还没做过）：

`mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf`

应用 Mac 的 Home Manager 配置：

`nix shell github:nix-community/home-manager/release-25.11#home-manager -c home-manager switch --flake .#siyuan@mbp`

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