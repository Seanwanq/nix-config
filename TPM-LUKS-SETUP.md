# TPM 2.0 自动解锁 LUKS 加密磁盘配置指南

## 概述

使用 TPM 2.0 芯片存储 LUKS 解密密钥，实现开机自动解锁，只需在桌面登录时输入密码。

## 优势

✅ **更安全**: 密钥存储在 TPM 芯片中，比密码更安全  
✅ **更优雅**: 开机时自动解锁，无需手动输入密码  
✅ **仍然需要登录**: 到达桌面后仍需输入用户密码登录  
✅ **防篡改**: TPM 会检测 BIOS/固件/引导加载器的变化，如果被篡改会拒绝解锁

## 前置要求

1. **TPM 2.0 芯片** - Dell G15 默认配备
2. **已启用 LUKS 加密** - 您已经配置好
3. **systemd-boot 引导加载器** - 您已经在使用

## 配置步骤

### 1. 导入 TPM 模块

编辑 `/home/sean/Projects/nix-config/hosts/dell-g15/default.nix`，在 `imports` 部分添加：

```nix
imports = [
  ../../modules/system.nix
  ../../modules/power-management.nix
  ../../modules/tpm-luks.nix        # 👈 添加这一行
  ../../modules/niri.nix
  ../../modules/gnome.nix
  ./hardware-configuration.nix
];
```

### 2. 重建系统

```bash
just build-g15
```

### 3. 检查 TPM 是否可用

重启后，检查 TPM 状态：

```bash
# 检查 TPM 设备
ls -la /dev/tpm*

# 应该看到:
# /dev/tpm0
# /dev/tpmrm0

# 查看 TPM 信息
sudo tpm2_getcap properties-fixed
```

### 4. 查找您的 LUKS 设备 UUID

每台电脑的 LUKS 设备 UUID 都不同。有以下几种方法查找：

#### 🚀 快速方法：使用辅助脚本（推荐）

```bash
# 运行查找脚本
./find-luks-uuid.sh
```

这个脚本会自动使用多种方法查找您的 LUKS UUID，并给出可以直接使用的命令。

#### 方法 1：从 hardware-configuration.nix 查找

```bash
# 查看硬件配置文件
cat /etc/nixos/hardware-configuration.nix | grep luks
```

您会看到类似这样的输出：
```nix
boot.initrd.luks.devices."luks-52846d5d-f14e-4e5f-a167-fe1ff015b9ca".device = "/dev/disk/by-uuid/52846d5d-f14e-4e5f-a167-fe1ff015b9ca";
```

其中 `52846d5d-f14e-4e5f-a167-fe1ff015b9ca` 就是您的 LUKS UUID。

#### 方法 2：使用 lsblk 命令

```bash
# 查看所有块设备
lsblk -f
```

输出示例：
```
NAME        FSTYPE      LABEL UUID                                 MOUNTPOINT
nvme0n1                                                             
├─nvme0n1p1 vfat              E623-8214                            /boot
└─nvme0n1p2 crypto_LUKS       52846d5d-f14e-4e5f-a167-fe1ff015b9ca 
  └─luks... ext4              1ff0b5ba-18e1-43db-8616-ea0b25e00867 /
```

找到 `FSTYPE` 为 `crypto_LUKS` 的行，其 UUID 就是 LUKS 设备的 UUID。

#### 方法 3：使用 blkid 命令

```bash
# 查看所有块设备的详细信息（需要 root 权限）
sudo blkid | grep crypto_LUKS
```

输出示例：
```
/dev/nvme0n1p2: UUID="52846d5d-f14e-4e5f-a167-fe1ff015b9ca" TYPE="crypto_LUKS"
```

#### 方法 4：查看当前解锁的 LUKS 设备

```bash
# 查看 /dev/mapper 中的设备
ls -la /dev/mapper/

# 查看 cryptsetup 状态
sudo cryptsetup status /dev/mapper/luks-*
```

### 5. 注册 LUKS 密钥到 TPM

使用上面找到的 UUID，将密码注册到 TPM：

```bash
# 替换下面的 UUID 为您自己的 UUID
LUKS_UUID="52846d5d-f14e-4e5f-a167-fe1ff015b9ca"

# 将现有密码注册到 TPM
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/disk/by-uuid/$LUKS_UUID
```

**更简单的方法** - 直接使用设备路径：

```bash
# 如果您知道加密分区在哪里（通常是 nvme0n1p2 或 sda2）
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/nvme0n1p2
```

**执行过程**:
1. 系统会提示输入当前的 LUKS 密码
2. 输入密码后，密钥会被存储到 TPM 中
3. 完成后，TPM 解锁方式会被添加（原密码仍然有效）

**PCR 说明**:
- `PCR 0`: 固件代码（BIOS/UEFI）
- `PCR 7`: 安全启动状态
- 使用这两个 PCR 确保系统未被篡改时才能解锁

### 6. 验证 TPM 密钥已注册

```bash
# 替换为您的 UUID 或直接使用设备路径
sudo cryptsetup luksDump /dev/disk/by-uuid/您的UUID | grep -A 5 "systemd-tpm2"

# 或者使用设备路径
sudo cryptsetup luksDump /dev/nvme0n1p2 | grep -A 5 "systemd-tpm2"
```

您应该看到一个使用 systemd-tpm2 的密钥槽。

**完整查看所有密钥槽**：

```bash
sudo cryptsetup luksDump /dev/nvme0n1p2
```

输出示例：
```
LUKS header information
Version:        2
...
Keyslots:
  0: luks2
      Key:        512 bits
      ...
  1: systemd-tpm2
      Key:        512 bits
      ...
```

### 7. 测试自动解锁

重启系统：

```bash
sudo reboot
```

**预期行为**:
- ✅ 开机时**不再提示**输入 LUKS 密码
- ✅ 直接进入引导加载器（systemd-boot）
- ✅ 自动加载系统
- ✅ 到达登录界面后输入**用户密码**登录

## 安全考虑

### ✅ 这个方案安全吗？

**是的，而且比单纯的密码更安全！**

1. **物理安全**: 密钥存储在 TPM 芯片中，无法直接读取
2. **防篡改**: 如果有人修改了 BIOS、引导加载器或内核，TPM 会检测到 PCR 值变化，拒绝解锁
3. **仍需登录**: 进入系统后仍需输入用户密码，未授权者无法访问您的数据
4. **多重保护**: 您仍然保留原始密码，可以在 TPM 失败时使用

### 什么情况下 TPM 解锁会失败？

TPM 解锁会在以下情况失败（需要手动输入密码）：

- 🔧 更新了 BIOS/UEFI 固件
- 🔧 修改了 BIOS 设置（尤其是安全启动相关）
- 🔧 更换了主板或 TPM 芯片
- 🔧 有人试图篡改引导加载器

**这些都是期望的行为！** 说明 TPM 正在保护您的系统。

### 如果 TPM 解锁失败怎么办？

不用担心！系统会回退到密码输入：

1. TPM 解锁失败时，会自动提示输入 LUKS 密码
2. 输入您最初设置的密码即可
3. 进入系统后，重新注册 TPM 密钥（步骤 4）

## 高级选项

### 使用不同的 PCR 组合

如果您不使用安全启动，可以只使用 PCR 0 和 7：

```bash
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/disk/by-uuid/52846d5d-f14e-4e5f-a167-fe1ff015b9ca
```

**其他常用 PCR 组合**:

- `0+7`: BIOS + 安全启动（推荐）
- `0+1+2+3+7`: 更严格（包含硬件配置、固件、引导加载器等）
- `7` 仅安全启动状态

**注意**: PCR 越多，越安全，但也越容易因系统更新而失效。

### 移除 TPM 密钥

如果您想禁用 TPM 自动解锁，恢复到手动输入密码：

```bash
# 列出所有密钥槽（使用您的 UUID 或设备路径）
sudo cryptsetup luksDump /dev/nvme0n1p2

# 移除 TPM 密钥槽（例如槽位 1）
sudo systemd-cryptenroll /dev/nvme0n1p2 --wipe-slot=1
```

**⚠️ 警告**: 不要移除您的原始密码槽！至少保留一个密码槽作为备份。

### 添加额外的密码

您可以保留多个密码槽：

```bash
# 添加新密码（使用您的设备路径）
sudo cryptsetup luksAddKey /dev/nvme0n1p2
```

这样您可以有：
- 原始密码（槽位 0）
- TPM 密钥（槽位 1）
- 备份密码（槽位 2）

## 故障排除

### TPM 设备不存在

```bash
# 检查 TPM 是否在 BIOS 中启用
sudo dmesg | grep -i tpm

# 如果没有输出，进入 BIOS 启用 TPM:
# Security -> TPM 2.0 Security -> Enable
```

### 注册密钥时报错 "TPM2 not supported"

确保您已经重建了系统并启用了 TPM 支持：

```bash
# 检查 systemd-cryptenroll 是否支持 TPM
systemd-cryptenroll --help | grep tpm2

# 应该看到 --tpm2-device 等选项
```

### 更新 BIOS 后无法自动解锁

这是正常的！BIOS 更新会改变 PCR 值。解决方法：

1. 手动输入 LUKS 密码启动系统
2. 移除旧的 TPM 密钥
3. 重新注册新的 TPM 密钥

```bash
# 列出密钥槽（使用您的设备路径）
sudo cryptsetup luksDump /dev/nvme0n1p2

# 移除旧的 TPM 槽（假设是槽位 1）
sudo systemd-cryptenroll /dev/nvme0n1p2 --wipe-slot=1

# 重新注册
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/nvme0n1p2
```

### 仍然提示输入密码

检查 initrd 是否正确配置了 TPM 支持：

```bash
# 查看 initrd 内容
lsinitrd /boot/initrd* | grep tpm

# 应该看到 tpm 相关的模块和二进制文件
```

如果没有，确保：
1. `boot.initrd.systemd.enable = true`
2. `boot.initrd.systemd.enableTpm2 = true`
3. 重建系统: `just build-g15`

## 备份建议

⚠️ **重要**: 始终保留至少一个密码槽！

在注册 TPM 前，建议：

1. **记录密码**: 将 LUKS 密码保存在安全的地方（密码管理器）
2. **添加恢复密钥**: 创建一个强密码作为备份
3. **不要移除所有密码槽**: 保留至少一个密码槽

## 总结

使用 TPM 2.0 自动解锁 LUKS：

✅ 更安全 - 密钥存储在硬件中  
✅ 更优雅 - 无需在启动时输入密码  
✅ 防篡改 - 检测系统修改  
✅ 保留密码 - 原密码仍然有效  

这是目前最优雅且安全的磁盘加密解锁方式！

## 参考链接

- [Arch Wiki - TPM](https://wiki.archlinux.org/title/Trusted_Platform_Module)
- [systemd-cryptenroll man page](https://www.freedesktop.org/software/systemd/man/systemd-cryptenroll.html)
- [NixOS TPM2 options](https://search.nixos.org/options?query=tpm2)
