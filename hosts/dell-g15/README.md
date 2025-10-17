# Dell G15 Setup Guide

## Quick Start

Your Dell G15 host configuration has been created. Follow these steps to complete the setup:

## Step 1: Generate Hardware Configuration

On your Dell G15 laptop, run:
```bash
sudo nixos-generate-config --show-hardware-config
```

Copy the output and replace the contents of:
`/home/sean/Projects/nix-config/hosts/dell-g15/hardware-configuration.nix`

**Important**: Make sure to update:
- File system UUIDs for `/` and `/boot`
- Kernel modules (especially for GPU)
- CPU type (Intel or AMD)

## Step 2: Configure Graphics (if needed)

The Dell G15 often comes with NVIDIA graphics. If you have an NVIDIA GPU:

1. Uncomment the NVIDIA configuration in `hardware-configuration.nix`
2. Find your GPU bus IDs:
```bash
lspci | grep -E "VGA|3D"
```

3. Update the `intelBusId` and `nvidiaBusId` accordingly

## Step 3: Review Configuration

Check and modify `hosts/dell-g15/default.nix`:
- Choose window manager (i3, sway, or niri)
- Enable/configure power management
- Adjust other laptop-specific settings

## Step 4: Build and Switch

From your nix-config directory:
```bash
# Test the configuration
sudo nixos-rebuild dry-build --flake .#dell-g15

# Build and switch
sudo nixos-rebuild switch --flake .#dell-g15
```

## Configuration Features

Your Dell G15 configuration includes:
- ✅ systemd-boot bootloader (modern UEFI)
- ✅ NetworkManager for WiFi
- ✅ Power management (power-profiles-daemon)
- ✅ Bluetooth support
- ✅ Backlight control
- ✅ i3 window manager (switchable to sway/niri)
- ✅ Home-manager integration
- ✅ Limited boot generations (10) to save space

## Optional Tweaks

### Switch to TLP for Better Battery Life
Edit `hosts/dell-g15/default.nix`:
- Comment out `services.power-profiles-daemon.enable = true;`
- Uncomment the TLP configuration block

### Enable NVIDIA GPU
Uncomment the NVIDIA section in `hardware-configuration.nix` and configure the bus IDs

### Change Window Manager
Edit the imports section in `default.nix` to switch between i3, sway, or niri

## Troubleshooting

If you encounter issues:
```bash
# Check for errors
sudo nixos-rebuild build --flake .#dell-g15 --show-trace

# View logs
journalctl -xb
```
