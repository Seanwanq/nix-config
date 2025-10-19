#!/usr/bin/env bash

# 查找 LUKS 加密设备 UUID 的辅助脚本
# 用法: ./find-luks-uuid.sh

echo "🔍 正在查找 LUKS 加密设备..."
echo ""

# 方法 1: 从 hardware-configuration.nix 查找
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📄 方法 1: 从 NixOS 硬件配置查找"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f /etc/nixos/hardware-configuration.nix ]; then
  LUKS_FROM_CONFIG=$(grep -oP 'boot\.initrd\.luks\.devices\."[^"]+"\s*=\s*\{\s*device\s*=\s*"/dev/disk/by-uuid/\K[^"]+' /etc/nixos/hardware-configuration.nix)
  if [ -n "$LUKS_FROM_CONFIG" ]; then
    echo "✅ 找到 LUKS UUID: $LUKS_FROM_CONFIG"
    LUKS_UUID="$LUKS_FROM_CONFIG"
  else
    echo "❌ 未在 hardware-configuration.nix 中找到 LUKS 配置"
  fi
else
  echo "❌ 未找到 /etc/nixos/hardware-configuration.nix"
fi

echo ""

# 方法 2: 使用 lsblk 查找
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💾 方法 2: 使用 lsblk 命令"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

LUKS_DEVICES=$(lsblk -f -o NAME,FSTYPE,UUID | grep crypto_LUKS)
if [ -n "$LUKS_DEVICES" ]; then
  echo "$LUKS_DEVICES" | while read -r line; do
    DEVICE=$(echo "$line" | awk '{print $1}')
    UUID=$(echo "$line" | awk '{print $3}')
    echo "✅ 设备: /dev/$DEVICE"
    echo "   UUID: $UUID"
    LUKS_UUID="$UUID"
  done
else
  echo "❌ 未找到 crypto_LUKS 类型的设备"
fi

echo ""

# 方法 3: 使用 blkid 查找
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔐 方法 3: 使用 blkid 命令（需要 root）"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v blkid &> /dev/null; then
  BLKID_OUTPUT=$(sudo blkid 2>/dev/null | grep crypto_LUKS)
  if [ -n "$BLKID_OUTPUT" ]; then
    echo "$BLKID_OUTPUT" | while read -r line; do
      DEVICE=$(echo "$line" | cut -d: -f1)
      UUID=$(echo "$line" | grep -oP 'UUID="\K[^"]+')
      echo "✅ 设备: $DEVICE"
      echo "   UUID: $UUID"
      LUKS_UUID="$UUID"
    done
  else
    echo "❌ 未找到 crypto_LUKS 设备（可能需要 root 权限）"
  fi
else
  echo "❌ blkid 命令不可用"
fi

echo ""

# 方法 4: 检查当前活动的 LUKS 设备
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔓 方法 4: 当前已解锁的 LUKS 设备"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v cryptsetup &> /dev/null; then
  MAPPER_DEVICES=$(ls /dev/mapper/ 2>/dev/null | grep -E "luks|crypt")
  if [ -n "$MAPPER_DEVICES" ]; then
    echo "$MAPPER_DEVICES" | while read -r mapper; do
      if [ -e "/dev/mapper/$mapper" ]; then
        echo "✅ 已解锁设备: /dev/mapper/$mapper"
        STATUS=$(sudo cryptsetup status "/dev/mapper/$mapper" 2>/dev/null)
        if [ -n "$STATUS" ]; then
          echo "$STATUS" | grep -E "device:|cipher:|type:"
        fi
        echo ""
      fi
    done
  else
    echo "❌ 未找到已解锁的 LUKS 设备"
  fi
else
  echo "❌ cryptsetup 命令不可用"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 总结"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -n "$LUKS_UUID" ]; then
  echo ""
  echo "🎯 您的 LUKS UUID 是:"
  echo ""
  echo "   $LUKS_UUID"
  echo ""
  echo "📋 使用以下命令注册到 TPM:"
  echo ""
  echo "   sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/disk/by-uuid/$LUKS_UUID"
  echo ""
  
  # 尝试找到设备路径
  DEVICE_PATH=$(lsblk -f -o NAME,UUID | grep "$LUKS_UUID" | awk '{print "/dev/" $1}')
  if [ -n "$DEVICE_PATH" ]; then
    echo "📋 或使用设备路径:"
    echo ""
    echo "   sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 $DEVICE_PATH"
    echo ""
  fi
else
  echo "❌ 未能找到 LUKS UUID"
  echo ""
  echo "💡 可能的原因:"
  echo "   - 系统未使用 LUKS 加密"
  echo "   - 需要 root 权限运行某些命令"
  echo "   - LUKS 设备未挂载"
  echo ""
  echo "💡 建议:"
  echo "   1. 确认系统是否使用了磁盘加密"
  echo "   2. 尝试使用 sudo 运行此脚本"
  echo "   3. 查看 /etc/nixos/hardware-configuration.nix 文件"
fi

echo ""
