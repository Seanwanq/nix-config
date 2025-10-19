# OBS Studio 录制失败问题解决方案

## 问题现象

启动录制时出现错误：
```
Failed to start recording
Starting the output failed. Please check the log for details.
Note: If you are using the NVENC or AMD encoders, make sure your video drivers are up to date.
```

## 原因分析

这个错误通常由以下原因引起：

1. **硬件编码器配置问题** - OBS 尝试使用 NVENC (NVIDIA) 或 VAAPI 编码器，但驱动或配置不正确
2. **输出路径权限问题** - 无法写入录制文件的目标目录
3. **编码器不可用** - 选择的编码器在系统上不可用

## 解决方案

### 方案 1: 使用软件编码器 (x264) - 推荐

我已经在配置中设置了默认使用 x264 软件编码器，这是最兼容的方案。

重新构建配置后：

```bash
just build-g15
```

重新登录，然后再次尝试录制。

### 方案 2: 手动配置 OBS 编码器

如果重建后仍有问题，请在 OBS 中手动配置：

1. 打开 OBS Studio
2. 点击 **Settings** (设置)
3. 选择 **Output** (输出)
4. 确保 **Output Mode** 设置为 **Simple**
5. 在 **Recording** 部分：
   - **Recording Quality**: 选择 **Same as stream** 或 **High Quality, Medium File Size**
   - **Recording Format**: **mp4**
   - **Encoder**: 选择 **Software (x264)**（不要选择 NVENC 或 VAAPI）

6. 点击 **OK** 保存
7. 再次尝试录制

### 方案 3: 检查录制路径

1. 在 OBS 设置中，进入 **Output** → **Recording**
2. 检查 **Recording Path** 是否指向有效目录（如 `~/Videos`）
3. 确保该目录存在并有写入权限：

```bash
mkdir -p ~/Videos
chmod 755 ~/Videos
```

### 方案 4: 使用 Intel VAAPI 硬件编码（可选）

如果您想使用硬件加速，可以尝试 Intel VAAPI：

1. 在 OBS 设置中，选择 **Output**
2. 将 **Output Mode** 改为 **Advanced**
3. 在 **Recording** 标签页：
   - **Type**: Standard
   - **Recording Path**: `~/Videos`
   - **Recording Format**: mp4
   - **Encoder**: **FFMPEG VAAPI H.264**
   
4. 点击 **OK**
5. 尝试录制

如果 VAAPI 也失败，说明硬件编码在您的系统上有问题，请继续使用 x264 软件编码。

### 方案 5: 查看详细日志

如果问题仍然存在，查看 OBS 日志以获取更多信息：

1. 在 OBS 中，点击 **Help** → **Log Files** → **View Current Log**
2. 查找包含 "error" 或 "failed" 的行
3. 特别注意关于编码器的错误信息

日志文件也可以在这里找到：
```
~/.config/obs-studio/logs/
```

## 配置文件位置

OBS 的配置文件位置：
- 全局配置: `~/.config/obs-studio/global.ini`
- 场景配置: `~/.config/obs-studio/basic/scenes/*.json`
- 日志文件: `~/.config/obs-studio/logs/`

## 验证配置

重建配置后，验证：

```bash
# 检查配置文件是否存在
cat ~/.config/obs-studio/global.ini

# 检查 Videos 目录
ls -la ~/Videos
```

## 推荐的录制设置

**对于大多数用途：**
- **编码器**: Software (x264)
- **分辨率**: 1920x1080
- **帧率**: 30 FPS
- **质量**: High Quality, Medium File Size
- **格式**: MP4

**如果文件太大：**
- 降低比特率
- 使用 720p 而不是 1080p
- 使用 30 FPS 而不是 60 FPS

**如果性能不够：**
- 使用 x264 的 "veryfast" 或 "ultrafast" 预设
- 降低输出分辨率
- 降低帧率到 24 或 30 FPS

## 环境变量检查

确保以下环境变量正确设置（已在 NixOS 配置中包含）：

```bash
echo $LIBVA_DRIVER_NAME  # 应该是 iHD 或 i965
echo $NIXOS_OZONE_WL     # 应该是 1
```

## 重置 OBS 配置

如果一切都失败了，可以重置 OBS 配置：

```bash
# 备份现有配置
mv ~/.config/obs-studio ~/.config/obs-studio.backup

# 重新启动 OBS（会创建新的默认配置）
obs
```

然后重新配置 OBS，使用 x264 编码器。

## 下一步

1. 运行 `just build-g15` 重建配置
2. 重新登录系统
3. 启动 OBS Studio
4. 尝试录制

如果仍然有问题，请查看 OBS 日志文件以获取更多详细信息。
