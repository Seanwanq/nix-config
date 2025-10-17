# Noctalia 配置说明

Noctalia 是一个现代化的 Wayland 桌面 Shell，专为 Niri 等窗口管理器设计。

## 配置架构

Noctalia 通过以下文件配置：

1. **`flake.nix`**: 添加了 `quickshell` 和 `noctalia` flake 输入
2. **`flake.nix` (dell-g15 配置)**: 在 home-manager 中导入了 Noctalia 模块
3. **`home/niri/noctalia.nix`**: Noctalia 的详细配置（顶栏部件等）
4. **`home/niri/config.kdl`**: Niri 配置，包含 Noctalia 的自动启动和键绑定

## 已配置的功能

### 自动启动
- Noctalia shell 会在 Niri 启动时自动运行（在 `config.kdl` 中配置）

### 键绑定

| 键绑定 | 功能 |
|--------|------|
| `Mod+Space` | 切换应用启动器 |
| `Mod+P` | 切换会话菜单 |
| `Super+Alt+L` | 锁屏 |
| `XF86AudioRaiseVolume` | 增加音量 |
| `XF86AudioLowerVolume` | 降低音量 |
| `XF86AudioMute` | 静音/取消静音 |
| `XF86AudioMicMute` | 麦克风静音/取消静音 |

### 顶栏部件

**左侧:**
- 侧边栏切换按钮（带发行版 logo）
- 活动窗口标题
- 媒体播放器迷你控件

**中央:**
- 工作区指示器

**右侧:**
- 屏幕录制工具
- 系统托盘
- 通知历史
- 电池状态（始终显示百分比，20% 警告阈值）
- 音量控制
- 时钟（格式：HH:mm）
- 会话菜单

## 配置文件位置

- **Flake 输入**: `/home/sean/Projects/nix-config/flake.nix`
- **Noctalia 设置**: `/home/sean/Projects/nix-config/home/niri/noctalia.nix`
- **Niri 配置（键绑定等）**: `/home/sean/Projects/nix-config/home/niri/config.kdl`

## 自定义配置

### 修改顶栏部件

在 `home/niri/noctalia.nix` 中修改 `programs.noctalia-shell.settings` 来自定义顶栏布局和部件。

### 修改键绑定

在 `home/niri/config.kdl` 中的 `binds` 部分修改 Noctalia 相关的键绑定。

### 查看配置差异

如果你通过 GUI 修改了设置，可以运行以下命令查看差异：

```bash
nix shell nixpkgs#jq nixpkgs#colordiff -c bash -c "diff -u <(jq -S . ~/.config/noctalia/settings.json) <(jq -S . ~/.config/noctalia/gui-settings.json) | colordiff"
```

## 构建和部署

```bash
# 构建并切换到新配置
just build-g15

# 或手动构建
sudo nixos-rebuild switch --flake .#dell-g15
```

## 使用 Noctalia

重启系统或重新登录 Niri 会话后：

1. Noctalia 会自动启动并显示在屏幕顶部
2. 使用 `Mod+Space` 打开应用启动器
3. 使用 `Mod+P` 打开会话菜单（关机、重启等）
4. 点击顶栏部件进行交互（音量、Wi-Fi、蓝牙等）

## 故障排除

### Noctalia 没有启动

检查 Noctalia 进程：
```bash
ps aux | grep noctalia
```

手动启动：
```bash
noctalia-shell
```

查看日志：
```bash
journalctl --user -u noctalia-shell -f
```

### 键绑定不工作

确保 Niri 配置已正确加载：
```bash
cat ~/.config/niri/config.kdl | grep noctalia
```

## 更多信息

- [Noctalia 官方文档](https://docs.noctalia.dev/)
- [Noctalia GitHub](https://github.com/noctalia-dev/noctalia-shell)
- [NixOS 安装指南](https://docs.noctalia.dev/getting-started/nixos/)
- [配置默认值](https://github.com/noctalia-dev/noctalia-shell/blob/main/Assets/settings-default.json)

