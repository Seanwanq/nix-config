# rclone OneDrive 配置

## 概述

此配置使用 Nix 管理 rclone 和 systemd 挂载服务，但 rclone 配置文件本身由用户手动管理（不在 Git 中）。

这种混合方式的优点：
- ✅ systemd 服务由 Nix 声明式管理
- ✅ 密钥不会提交到 Git
- ✅ token 可以自动刷新
- ✅ 跨机器迁移简单（只需复制配置文件）

## 文件说明

- `rclone.nix` - Nix 配置文件（定义 systemd 服务）
- `~/.config/rclone/rclone.conf` - rclone 配置文件（用户手动管理）

## 在新机器上首次配置

### 方法 1: 手动配置（推荐用于首次设置）

1. **构建 Nix 配置**（这会安装 rclone 和创建 systemd 服务）：
   ```bash
   just build-g15  # 或你的构建命令
   ```

2. **配置 OneDrive**：
   ```bash
   rclone config
   ```
   - 选择 `n` (新建 remote)
   - 名称输入 `onedrive`（必须是这个名称）
   - 选择 Microsoft OneDrive
   - 完成 OAuth 认证流程
   - 选择你的 OneDrive 账户和驱动器

3. **启动服务**：
   ```bash
   systemctl --user start rclone-onedrive.service
   systemctl --user enable rclone-onedrive.service
   ```

4. **验证挂载**：
   ```bash
   ls ~/OneDrive
   df -h | grep OneDrive
   ```

### 方法 2: 从现有机器迁移（用于多台机器）

如果你已经在一台机器上配置好了：

1. **在原机器上备份配置**：
   ```bash
   # 方式 A: 复制到 USB 或其他位置
   cp ~/.config/rclone/rclone.conf /path/to/backup/

   # 方式 B: 使用同步工具（如果已经挂载了 OneDrive）
   cp ~/.config/rclone/rclone.conf ~/OneDrive/backups/
   ```

2. **在新机器上**：
   ```bash
   # 构建 Nix 配置
   just build-g15

   # 恢复 rclone 配置
   mkdir -p ~/.config/rclone
   cp /path/to/backup/rclone.conf ~/.config/rclone/

   # 启动服务
   systemctl --user start rclone-onedrive.service
   systemctl --user enable rclone-onedrive.service
   ```

3. **验证**：
   ```bash
   ls ~/OneDrive
   ```

## 服务管理

### 查看服务状态
```bash
systemctl --user status rclone-onedrive.service
```

### 重启服务
```bash
systemctl --user restart rclone-onedrive.service
```

### 查看日志
```bash
journalctl --user -u rclone-onedrive.service -f
```

### 手动挂载/卸载
```bash
# 挂载
mkdir -p ~/OneDrive
rclone mount onedrive: ~/OneDrive --daemon

# 卸载
fusermount -u ~/OneDrive
```

## 性能优化说明

当前配置包含以下性能优化：

- **VFS 缓存模式**: `writes` - 写入时缓存，提高写入性能
- **缓存保留时间**: 24小时
- **读取块大小**: 128MB - 优化大文件读取
- **Buffer 大小**: 64MB
- **使用 mmap**: 优化内存映射
- **目录缓存**: 12小时 - 减少 API 调用
- **轮询间隔**: 15秒 - 平衡同步频率和性能

## 安全注意事项

⚠️ **重要**：

1. `~/.config/rclone/rclone.conf` 包含你的 OneDrive access token，请妥善保管
2. 该文件**不在** Git 中，不会被意外提交
3. 建议定期备份到安全位置（加密 USB、密码管理器、私有云存储等）
4. 如果 token 泄露，请立即在 Microsoft 账户设置中撤销应用权限

## 备份和恢复最佳实践

### 推荐的备份方式

**方式 1: 使用 OneDrive 本身备份**（一旦挂载成功）
```bash
mkdir -p ~/OneDrive/system-config
cp ~/.config/rclone/rclone.conf ~/OneDrive/system-config/
```

**方式 2: 使用 git-crypt 或 sops-nix**（高级用户）

对于更高的安全性，可以使用加密工具：
- [git-crypt](https://github.com/AGWA/git-crypt) - 透明加密 Git 文件
- [sops-nix](https://github.com/Mic92/sops-nix) - 使用 age/GPG 加密密钥
- [agenix](https://github.com/ryantm/agenix) - 基于 age 的密钥管理

### 恢复配置

在新机器上：
```bash
# 从备份恢复
mkdir -p ~/.config/rclone
cp /path/to/backup/rclone.conf ~/.config/rclone/

# 或从 OneDrive 恢复（如果有其他方式先访问）
# ... 先用其他机器将文件放到可访问位置 ...
```

## 故障排查

### 服务启动失败
```bash
# 查看详细日志
journalctl --user -u rclone-onedrive.service -n 50

# 检查配置文件
cat ~/.config/rclone/rclone.conf

# 手动测试挂载
rclone mount onedrive: ~/OneDrive --vfs-cache-mode writes -vv
```

### Token 过期
Token 会自动刷新，如果遇到问题：
```bash
rclone config reconnect onedrive:
```

### 挂载点无响应
```bash
# 强制卸载
fusermount -uz ~/OneDrive

# 重启服务
systemctl --user restart rclone-onedrive.service
```
