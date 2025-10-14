# Hyper-V NixOS 显示问题诊断指南

## 已做的 NixOS 配置修改

### 1. `hosts/nixos-hv/default.nix`
- ✅ 添加了 Hyper-V 显示驱动内核模块：`hyperv_fb` 和 `hyperv_drm`
- ✅ 设置内核参数强制指定分辨率
- ✅ 移除了无效的 X11 相关配置（xrandr 等）
- ✅ 添加了 Wayland 环境变量

### 2. `home/sway/default.nix`
- ✅ 添加了智能分辨率检测脚本
- ✅ 自动尝试多种分辨率设置
- ✅ 改进了调试快捷键

## 下一步操作

### 步骤 1: 重新构建 NixOS 配置
在虚拟机中运行：
```bash
sudo nixos-rebuild switch --flake .#nixos-hv
```

### 步骤 2: 重启虚拟机
```bash
sudo reboot
```

### 步骤 3: 检查显示驱动是否加载（重启后）
```bash
# 检查内核模块
lsmod | grep hyperv

# 检查 DRM 设备
ls -la /dev/dri/

# 查看内核日志中的显示相关信息
dmesg | grep -i -E "drm|hyperv|video|fb"
```

### 步骤 4: 在 Sway 中检查输出
启动 Sway 后，按 `Super+Shift+O` 查看检测到的输出和支持的分辨率。

或在终端中运行：
```bash
swaymsg -t get_outputs
```

### 步骤 5: 手动尝试设置分辨率
如果自动设置不起作用，在 Sway 中按 `Super+Shift+R` 强制设置。

或在终端中尝试：
```bash
# 获取输出名称
swaymsg -t get_outputs | grep "name"

# 设置分辨率（替换 OUTPUT_NAME）
swaymsg output OUTPUT_NAME mode 2560x1440
```

## Hyper-V 主机端配置（重要！）

### **关键：Hyper-V 增强会话模式**

Hyper-V 有两种连接模式：

#### 选项 A：使用增强会话模式（推荐）
这需要在虚拟机中安装 xrdp：

1. 在 `hosts/nixos-hv/default.nix` 中添加：
```nix
services.xrdp = {
  enable = true;
  defaultWindowManager = "sway";
};

# 允许 RDP 端口
networking.firewall.allowedTCPPorts = [ 3389 ];
```

2. 在 Hyper-V Manager 中：
   - 关闭虚拟机
   - 打开虚拟机设置
   - 找到 "Display" 设置
   - 设置分辨率为 2560x1440
   - 启用增强会话模式

#### 选项 B：禁用增强会话模式（简单但功能受限）

1. 在 PowerShell（管理员）中运行：
```powershell
# 针对特定虚拟机禁用
Set-VM -VMName "nixos-hv" -EnhancedSessionTransportType HvSocket

# 或全局禁用
Set-VMHost -EnableEnhancedSessionMode $false
```

2. 在 Hyper-V Manager 中设置虚拟机显示：
   - 虚拟机设置 → Display
   - 设置 Maximum resolution 为 2560x1440

### **检查虚拟机显示设置**

在 Hyper-V Manager 中：
1. 右键点击虚拟机 → Settings
2. 找到 "Display" 或"显示"
3. 确保设置如下：
   - Maximum resolution: 2560 x 1440
   - Monitor count: 1
   - 不勾选 "Enable virtual TPM"（如果有的话，可能影响显示）

## 备选方案

### 方案 1：使用 GRUB 图形模式
在 `hosts/nixos-hv/default.nix` 中：
```nix
boot.loader.grub = {
  gfxmodeEfi = "2560x1440";
  gfxmodeBios = "2560x1440";
};
```

### 方案 2：切换回 X11（不推荐但可能更兼容）
如果 Wayland/Sway 在 Hyper-V 中问题太多，可以：
1. 切换到 i3 窗口管理器（使用 X11）
2. 在 `hosts/nixos-hv/default.nix` 中启用 `modules/i3.nix` 而不是 `modules/sway.nix`

### 方案 3：使用 wlroots 的 headless 后端
在 `home/sway/default.nix` 的 `extraConfig` 中添加：
```nix
# 使用 headless 后端加上 VNC
exec wayvnc 0.0.0.0 5900
```

然后从主机通过 VNC 连接。

## 常见问题

### Q: 分辨率仍然很小
A: 检查 Hyper-V 虚拟机设置中的显示分辨率限制。

### Q: Sway 无法启动
A: 查看日志：`journalctl -xe | grep sway`

### Q: 显示黑屏
A: 可能是驱动问题，尝试在内核参数中添加 `nomodeset` 或使用 `video=efifb:off`

## 调试命令总结

```bash
# 查看 Sway 输出和分辨率
swaymsg -t get_outputs

# 查看内核显示驱动
lsmod | grep -E "drm|fb|hyperv"

# 查看 DRM 设备
ls -la /dev/dri/

# 查看系统日志
journalctl -b | grep -i -E "sway|drm|video"

# 测试手动设置分辨率
swaymsg output \* mode 2560x1440
```

## 联系和下一步

完成上述步骤后，请告诉我：
1. 内核模块是否正确加载（`lsmod | grep hyperv` 的输出）
2. Sway 检测到的输出信息（`swaymsg -t get_outputs` 的输出）
3. Hyper-V 虚拟机显示设置的截图

这样我可以进一步帮你调试！
