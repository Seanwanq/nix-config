# 电源管理配置说明

本配置为 Dell G15 笔记本提供了完整的电源管理方案。

## 配置文件

- **模块**: `/modules/power-management.nix` - 系统级电源管理
- **主机配置**: `/hosts/dell-g15/default.nix` - 导入电源管理模块
- **Noctalia**: `/home/programs/noctalia.nix` - 电池充电阈值（80%）

## 功能特性

### 1. 电池充电保护

#### 系统级 (TLP)
- **充电阈值**: 75%-80%
  - 电量低于 75% 时才开始充电
  - 充到 80% 就停止充电
  - 延长电池寿命，减少充电循环

#### Noctalia Shell
- **充电模式**: Balanced (80%)
  - 通过 Noctalia 的电池管理面板可以切换模式
  - Full (100%): 充满到 100%
  - Balanced (80%): 推荐日常使用
  - Lifespan (60%): 长期不用时使用

**激活 Noctalia 电池管理**:
1. 首次使用需要安装 battery manager（需要 root 权限）
2. 点击 Noctalia 顶栏的电池图标
3. 打开电池管理面板，会提示安装
4. 选择充电模式（推荐 Balanced）

### 2. TLP 电源管理

#### CPU 调度
- **AC 模式 (接电源)**: Performance（性能）
  - 启用 CPU 睿频
  - 无频率限制
  - 适合游戏和高性能任务

- **Battery 模式 (电池)**: Powersave（省电）
  - 禁用 CPU 睿频
  - 限制最大频率 3 GHz
  - 延长续航时间

#### GPU 控制
- **Intel Iris Xe 图形卡**:
  - AC: 最大 1450 MHz
  - Battery: 限制 800 MHz
  - 平衡性能和续航

#### 平台配置
- AC: Performance profile
- Battery: Low-power profile

### 3. 盒盖和电源按钮行为

通过 `systemd-logind` 配置：

| 事件 | 行为 |
|------|------|
| 合盖 (lidSwitch) | 挂起 (suspend) |
| 接电源合盖 (lidSwitchExternalPower) | 挂起 |
| 外接显示器合盖 (lidSwitchDocked) | 挂起 |
| 按电源按钮 (powerKey) | 挂起 |
| 长按电源按钮 (powerKeyLongPress) | 关机 |
| 空闲 30 分钟 (idleAction) | 挂起 |

**修改行为**:
编辑 `/modules/power-management.nix` 中的 `services.logind` 部分：
- `suspend`: 挂起到内存（快速恢复）
- `hibernate`: 休眠到磁盘（省电但恢复慢）
- `ignore`: 不执行任何操作
- `poweroff`: 关机
- `lock`: 仅锁屏

**示例 - 外接显示器时合盖不挂起**:
```nix
services.logind = {
  lidSwitch = "suspend";              # 正常情况合盖挂起
  lidSwitchDocked = "ignore";         # 外接显示器时忽略
  lidSwitchExternalPower = "ignore";  # 接电源时忽略
};
```

### 4. 低电量保护

通过 `UPower` 配置电池保护：
- **20%**: 低电量警告
- **10%**: 临界电量警告  
- **5%**: 自动休眠（Hibernate）保护数据

### 5. ACPI 事件处理

自定义 ACPI 事件响应：
- **合盖事件**: 触发挂起
- **AC 适配器插拔**: 自动切换电源配置文件
- 事件日志记录在系统日志中

### 6. 温度管理

- **thermald**: Intel CPU 温度自动管理
  - 防止过热
  - 动态调整性能
  - 保护硬件

### 7. 存储设备优化

#### NVMe SSD
- 启用深度电源状态
- 延迟 5500 微秒（平衡性能和省电）
- 禁用 IO 调度器（NVMe 不需要）

#### SATA
- AC: 最大性能
- Battery: 中等功耗 + DIPM

### 8. 其他省电特性

- **WiFi 省电**: 电池模式启用
- **USB 自动挂起**: 启用（排除手机）
- **声卡省电**: 电池模式 1 秒后休眠
- **PCIe ASPM**: 电池模式启用 PowerSupersave
- **运行时电源管理**: 电池模式自动管理

## 使用工具

### 电源状态查看

```bash
# 查看 TLP 状态和配置
sudo tlp-stat

# 查看详细的电池和充电信息
sudo tlp-stat -b

# 查看 CPU、GPU 频率和调度器
sudo tlp-stat -p

# 查看电源消耗分析
sudo powertop

# 查看 ACPI 信息
acpi -V

# 查看电池信息
upower -i /org/freedesktop/UPower/devices/battery_BAT0

# 查看温度
sensors

# 查看电源按钮/盒盖配置
loginctl show-user $USER
```

### 手动控制

```bash
# 手动切换 CPU 调度器
echo "powersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# 手动设置充电阈值 (Dell)
echo 80 | sudo tee /sys/class/power_supply/BAT0/charge_control_end_threshold

# 手动触发挂起
systemctl suspend

# 手动触发休眠
systemctl hibernate

# 手动触发混合睡眠
systemctl hybrid-sleep
```

### 屏幕亮度控制

```bash
# 增加亮度
brightnessctl set +10%

# 降低亮度
brightnessctl set 10%-

# 设置具体值
brightnessctl set 50%

# 查看当前亮度
brightnessctl get
```

## 故障排除

### 1. Noctalia 电池管理不工作

**问题**: 充电阈值设置后没有生效

**解决方案**:
```bash
# 检查 Noctalia battery manager 是否安装
ls -la /usr/bin/battery-manager-$USER

# 查看日志
journalctl --user -u noctalia-shell -f | grep -i battery

# 手动安装 battery manager
# 在 Noctalia 电池面板中点击安装按钮（需要输入密码）

# 检查硬件是否支持充电阈值
cat /sys/class/power_supply/BAT0/charge_control_end_threshold
```

### 2. TLP 充电阈值不生效

**问题**: TLP 配置的 75%-80% 阈值没有应用

**解决方案**:
```bash
# 检查 TLP 是否正在运行
systemctl status tlp

# 重启 TLP 服务
sudo systemctl restart tlp

# 检查电池特性支持
sudo tlp-stat -b | grep -i threshold

# Dell 笔记本需要 dell-smbios-wmi 模块
lsmod | grep dell

# 如果模块未加载，手动加载
sudo modprobe dell-smbios-wmi
```

### 3. 合盖后无法唤醒

**问题**: 合盖挂起后打开盖子无响应

**解决方案**:
```bash
# 查看挂起日志
journalctl -b | grep -i suspend

# 检查唤醒源
cat /proc/acpi/wakeup

# 启用键盘唤醒 (如果禁用)
echo LID0 | sudo tee /proc/acpi/wakeup

# 测试手动挂起
systemctl suspend
```

### 4. 电池续航差

**问题**: 电池续航时间短于预期

**诊断**:
```bash
# 使用 powertop 分析耗电
sudo powertop

# 查看哪些进程消耗最多电量 (Tab 键切换到进程视图)

# 查看 TLP 统计
sudo tlp-stat -p

# 检查 CPU 频率是否正确
watch -n 1 "cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq"
```

**优化建议**:
1. 关闭不用的后台应用
2. 降低屏幕亮度
3. 使用 Firefox 而非 Chrome（更省电）
4. 禁用蓝牙和 WiFi（如果不用）
5. 运行 `sudo powertop --auto-tune` 应用所有优化

### 5. 温度过高

**问题**: 笔记本温度高、风扇吵

**解决方案**:
```bash
# 查看温度
sensors

# 查看 thermald 状态
systemctl status thermald

# 重启 thermald
sudo systemctl restart thermald

# 手动限制 CPU 频率
sudo cpupower frequency-set -u 2.5GHz

# 检查是否有进程占用 CPU
top
```

### 6. 休眠 (Hibernate) 不工作

**问题**: 执行 `systemctl hibernate` 失败

**原因**: 休眠需要 swap 分区或 swap 文件

**解决方案**:
```bash
# 检查是否有 swap
swapon --show

# 如果没有 swap，创建 swap 文件 (16GB 为例)
sudo dd if=/dev/zero of=/swapfile bs=1M count=16384
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# 然后在 NixOS 配置中添加:
# swapDevices = [ { device = "/swapfile"; } ];
# boot.resumeDevice = "/swapfile";

# 重建配置
sudo nixos-rebuild switch
```

## 电池保养建议

1. **日常使用**: 使用 Balanced 模式 (80%)
2. **长期存放**: 充电到 50-60%，断开电源
3. **校准电池**: 每 3 个月完全充放电一次
   - 临时设置为 Full 模式 (100%)
   - 充满后正常使用至 5-10%
   - 再次充满到 100%
   - 恢复 Balanced 模式
4. **避免**: 长时间保持 100% 或 0% 电量
5. **温度**: 保持笔记本通风良好，避免高温

## 配置文件位置

- TLP 配置: `/etc/tlp.conf` (NixOS 自动生成)
- Logind 配置: `/etc/systemd/logind.conf` (NixOS 自动生成)
- UPower 配置: `/etc/UPower/UPower.conf` (NixOS 自动生成)
- ACPI 事件: `/etc/acpi/events/` 和 `/etc/acpi/actions/`
- Noctalia 设置: `~/.config/noctalia/settings.json`

## 监控命令快速参考

```bash
# 实时电池状态
watch -n 2 'acpi -V'

# 实时温度
watch -n 2 'sensors'

# 实时 CPU 频率
watch -n 1 'grep MHz /proc/cpuinfo'

# 实时功耗
sudo powertop

# TLP 完整报告
sudo tlp-stat > ~/tlp-report.txt
```

## 相关链接

- [TLP 官方文档](https://linrunner.de/tlp/)
- [ArchWiki - Power Management](https://wiki.archlinux.org/title/Power_management)
- [NixOS Wiki - Laptop](https://nixos.wiki/wiki/Laptop)
- [Noctalia Battery Manager](https://docs.noctalia.dev/)
