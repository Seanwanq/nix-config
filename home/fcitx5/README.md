# Fcitx5 Chinese Pinyin Input Configuration

This configuration enables Chinese Pinyin input method using Fcitx5 on NixOS.

## What's Configured

### System Level (`modules/system.nix`)
- **fcitx5**: Main input method framework
- **fcitx5-chinese-addons**: Provides Pinyin input support
- **fcitx5-gtk**: GTK integration for proper display
- **fcitx5-nord**: Nord color theme (optional)

### Home Manager Level (`home/fcitx5/default.nix`)
- **fcitx5-configtool**: GUI configuration tool
- **fcitx5-qt**: Qt integration

## Usage

### First Time Setup

1. After rebuilding your system, fcitx5 should start automatically via XDG autostart
2. Open the configuration tool:
   ```bash
   fcitx5-configtool
   ```
3. Add Chinese Pinyin input method:
   - Click "Input Method" tab
   - Click the "+" button
   - **Important**: Search for "cn" (not "Chinese") to find Simplified Chinese layouts
   - Look for "简体中文" → "Pinyin" and add it
   - You should now have both "Keyboard - English (US)" and "Pinyin" in your list

### Switching Input Methods

- **Default hotkey**: `Ctrl + Space` to switch between English and Pinyin
- **Custom hotkey**: Can be configured in fcitx5-configtool under Global Options

### Checking Status

To verify fcitx5 is running:
```bash
fcitx5-remote
```

To restart fcitx5:
```bash
fcitx5 -r
```

## Customization

### Theme and Font

You can customize the appearance by editing `~/.config/fcitx5/conf/classicui.conf`:

```ini
# Fcitx Theme
Theme=Nord-Dark
# Font
Font="Sans 12"
```

Alternatively, uncomment the home.file section in `default.nix` to manage this declaratively.

### Available Themes

The following themes are included in nixpkgs:
- `fcitx5-nord` (already configured)
- `fcitx5-rose-pine`
- `fcitx5-material-color`

To use a different theme, modify the `fcitx5.addons` list in `modules/system.nix`.

## Troubleshooting

### Fcitx5 not starting
- Verify XDG autostart is enabled in your window manager configuration
- For i3, check that `services.xserver.desktopManager.runXdgAutostartIfNone = true;` is set
- Manually start with: `fcitx5 -d`

### Input method not showing up
- Make sure you searched for "cn" not "Chinese" in fcitx5-configtool
- Check that `fcitx5-chinese-addons` is installed
- Verify environment variables are set (should be automatic with NixOS configuration)

### Can't type Chinese in certain applications
- Ensure the application supports input methods
- Try restarting the application after fcitx5 is running
- For Qt applications, make sure `fcitx5-qt` is installed (already in config)

## Environment Variables

NixOS automatically sets the required environment variables:
- `GTK_IM_MODULE=fcitx`
- `QT_IM_MODULE=fcitx`
- `XMODIFIERS=@im=fcitx`

You can verify these are set:
```bash
echo $GTK_IM_MODULE
echo $QT_IM_MODULE
echo $XMODIFIERS
```

## More Information

- [Fcitx5 NixOS Wiki](https://nixos.wiki/wiki/Fcitx5)
- [Fcitx5 Official Documentation](https://fcitx-im.org/wiki/Fcitx_5)
