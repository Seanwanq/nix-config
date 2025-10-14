#!/usr/bin/env bash
# xrdp 状态检查脚本

echo "=========================================="
echo "检查 xrdp 配置和状态"
echo "=========================================="
echo ""

echo "1. 检查 xrdp 服务状态:"
sudo systemctl status xrdp --no-pager
echo ""

echo "2. 检查 xrdp-sesman 服务状态:"
sudo systemctl status xrdp-sesman --no-pager
echo ""

echo "3. 检查 RDP 端口 (3389):"
sudo ss -tlnp | grep 3389
echo ""

echo "4. 检查防火墙规则:"
sudo iptables -L -n | grep 3389 || echo "没有找到 3389 端口的防火墙规则"
echo ""

echo "5. 检查 xrdp 配置文件:"
if [ -f /etc/xrdp/xrdp.ini ]; then
    echo "xrdp.ini 存在"
    grep -E "^port=|^address=" /etc/xrdp/xrdp.ini 2>/dev/null || echo "无法读取配置"
else
    echo "⚠️  xrdp.ini 不存在！xrdp 可能未正确安装"
fi
echo ""

echo "6. 检查当前用户组:"
groups
echo ""

echo "=========================================="
echo "请将以上输出截图或复制给我"
echo "=========================================="
