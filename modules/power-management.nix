{ config, lib, pkgs, ... }:

{
  # 电源管理配置
  
  # 禁用 power-profiles-daemon，改用 TLP（更强大的笔记本电源管理）
  services.power-profiles-daemon.enable = lib.mkForce false;
  
  # TLP - 高级笔记本电源管理
  services.tlp = {
    enable = true;
    settings = {
      # CPU 调度器
      CPU_SCALING_GOVERNOR_ON_AC = "performance";      # 接电源时性能模式
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";       # 电池时省电模式
      
      # CPU 能效策略 (Intel 第 6 代及以后的 CPU)
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      
      # CPU 加速模式
      CPU_BOOST_ON_AC = 1;                            # 接电源时启用睿频
      CPU_BOOST_ON_BAT = 0;                           # 电池时禁用睿频以省电
      
      # CPU 最小/最大频率 (百分比)
      CPU_SCALING_MIN_FREQ_ON_AC = 400000;            # AC: 400 MHz
      CPU_SCALING_MAX_FREQ_ON_AC = 9999999;           # AC: 无限制
      CPU_SCALING_MIN_FREQ_ON_BAT = 400000;           # BAT: 400 MHz  
      CPU_SCALING_MAX_FREQ_ON_BAT = 3000000;          # BAT: 限制在 3 GHz
      
      # 核心调度器 - 控制哪些 CPU 核心在线
      SCHED_POWERSAVE_ON_AC = 0;                      # AC: 所有核心在线
      SCHED_POWERSAVE_ON_BAT = 1;                     # BAT: 节能模式
      
      # Intel GPU
      INTEL_GPU_MIN_FREQ_ON_AC = 300;
      INTEL_GPU_MIN_FREQ_ON_BAT = 300;
      INTEL_GPU_MAX_FREQ_ON_AC = 1450;                # Iris Xe 最大频率
      INTEL_GPU_MAX_FREQ_ON_BAT = 800;                # 电池时限制 GPU
      INTEL_GPU_BOOST_FREQ_ON_AC = 1450;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 800;
      
      # 平台配置
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      
      # 磁盘设备 (NVMe SSD)
      DISK_DEVICES = "nvme0n1";
      DISK_APM_LEVEL_ON_AC = "254 254";               # 最大性能
      DISK_APM_LEVEL_ON_BAT = "128 128";              # 平衡
      DISK_IOSCHED = "none";                          # NVMe 不需要 IO 调度器
      
      # SATA 电源管理
      SATA_LINKPWR_ON_AC = "max_performance";
      SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
      
      # PCIe 活动状态电源管理 (ASPM)
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";
      
      # 运行时电源管理
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      
      # USB 自动挂起
      USB_AUTOSUSPEND = 1;
      USB_BLACKLIST_PHONE = 1;                        # 排除手机
      
      # 蓝牙自动关闭 (电池模式下长时间不用时)
      # DEVICES_TO_DISABLE_ON_STARTUP = "";           # 启动时不禁用任何设备
      # DEVICES_TO_ENABLE_ON_STARTUP = "bluetooth";   # 启动时启用蓝牙
      
      # 电池充电阈值 - Dell G15 特定
      # 这些设置需要笔记本硬件支持，Dell 通常支持
      START_CHARGE_THRESH_BAT0 = 75;                  # 电量低于 75% 时才开始充电
      STOP_CHARGE_THRESH_BAT0 = 80;                   # 充到 80% 就停止
      
      # 电池校准模式 (临时禁用阈值，用于电池校准)
      # NATACPI_ENABLE = 1;                           # 启用原生 ACPI 调用
      # TPACPI_ENABLE = 1;                            # 启用 ThinkPad ACPI
      # TPSMAPI_ENABLE = 1;                           # 启用 ThinkPad SMAPI
      
      # WiFi 电源管理
      WIFI_PWR_ON_AC = "off";                         # AC 模式关闭 WiFi 省电
      WIFI_PWR_ON_BAT = "on";                         # 电池模式开启 WiFi 省电
      
      # 声卡电源管理
      SOUND_POWER_SAVE_ON_AC = 0;                     # AC 模式关闭声卡省电
      SOUND_POWER_SAVE_ON_BAT = 1;                    # 电池模式 1 秒后进入省电
      SOUND_POWER_SAVE_CONTROLLER = "Y";
      
      # 屏幕背光节能
      # (由 brightnessctl/light 管理，这里不设置)
      
      # 笔记本模式 - 最大限度延长电池寿命
      # LAPTOP_MODE_ON_AC = 0;
      # LAPTOP_MODE_ON_BAT = 2;
    };
  };
  
  # 确保 TLP 服务正确启动
  systemd.services.tlp = {
    wantedBy = [ "multi-user.target" ];
  };
  
  # 盒盖和电源按钮行为配置
  services.logind = {
    # 合上盖子时挂起 (suspend)
    lidSwitch = "suspend";
    
    # 接电源时合上盖子仍然挂起（你可以改为 "ignore" 来保持运行）
    lidSwitchDocked = "suspend";
    
    # 外接显示器时合盖的行为
    lidSwitchExternalPower = "suspend";
    
    # 按下电源按钮时挂起（不是关机）
    powerKey = "suspend";
    
    # 空闲多久后不操作（0 表示禁用自动挂起）
    # idleAction = "suspend";
    # idleActionSec = "30min";                       # 30 分钟不操作后挂起
    
    # 其他 logind 额外配置通过 extraConfig
    extraConfig = ''
      HandleSuspendKey=suspend
      HandleHibernateKey=hibernate
      HandleLidSwitch=suspend
      HandleLidSwitchDocked=suspend
      HandleLidSwitchExternalPower=suspend
      IdleAction=suspend
      IdleActionSec=30min
    '';
  };
  
  # 休眠支持（需要 swap 分区或 swap 文件）
  # 如果你想启用休眠（hibernate），需要配置 swap 和 resume
  # boot.resumeDevice = "/dev/disk/by-uuid/your-swap-uuid";
  # boot.kernelParams = [ "resume=/dev/disk/by-uuid/your-swap-uuid" ];
  
  # 挂起和休眠优化
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30min
    SuspendState=mem
  '';
  
  # UPower 配置 - 改进电池管理和通知
  services.upower = {
    enable = true;
    percentageLow = 20;                               # 低电量阈值 20%
    percentageCritical = 10;                          # 临界电量阈值 10%
    percentageAction = 5;                             # 5% 时执行关键操作
    criticalPowerAction = "Hibernate";                # 临界电量时休眠（保护数据）
  };
  
  # ACPI 事件处理
  services.acpid = {
    enable = true;
    
    # 自定义 ACPI 事件处理器
    handlers = {
      # 合盖事件
      lid = {
        event = "button/lid.*";
        action = ''
          # 获取盒盖状态
          LID_STATE=$(cat /proc/acpi/button/lid/LID0/state | awk '{print $2}')
          
          if [ "$LID_STATE" = "closed" ]; then
            logger "ACPI: Lid closed, suspending..."
            systemctl suspend
          else
            logger "ACPI: Lid opened"
          fi
        '';
      };
      
      # AC 适配器插拔事件（TLP 会自动处理，这里仅记录日志）
      ac-adapter = {
        event = "ac_adapter.*";
        action = ''
          AC_STATE=$(cat /sys/class/power_supply/AC*/online)
          if [ "$AC_STATE" = "1" ]; then
            logger "ACPI: AC adapter connected, switching to AC profile"
          else
            logger "ACPI: AC adapter disconnected, switching to battery profile"
          fi
        '';
      };
    };
  };
  
  # 温度管理 - thermald (Intel 专用)
  services.thermald = {
    enable = true;
    # thermald 会自动管理 CPU 温度，防止过热
  };
  
  # 电源管理相关的内核模块
  boot.kernelModules = [
    "acpi_call"          # Dell BIOS 电池阈值控制需要
  ];
  
  # 额外的内核参数用于电源管理
  boot.kernelParams = [
    # Intel i915 图形驱动的省电选项
    "i915.enable_fbc=1"                # 帧缓冲压缩（省电）
    "i915.enable_psr=1"                # 面板自刷新（Panel Self Refresh，省电）
    "i915.fastboot=1"                  # 快速启动
    
    # NVMe 电源管理
    "nvme_core.default_ps_max_latency_us=5500"  # 允许 NVMe 进入更深的电源状态
  ];
  
  # 安装电源管理相关工具
  environment.systemPackages = with pkgs; [
    acpi                 # ACPI 信息查看工具
    acpid                # ACPI 事件守护进程
    powertop             # 电源消耗分析工具
    tlp                  # 已由 services.tlp 管理，但添加 CLI 工具
    brightnessctl        # 屏幕亮度控制
    lm_sensors           # 硬件传感器（温度、风扇等）
  ];
  
  # 用户组权限 - 允许用户控制电源相关功能
  users.groups.power = {};
  
  # udev 规则 - 允许普通用户控制背光和电源
  services.udev.extraRules = ''
    # 背光控制权限
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    
    # 电池充电阈值控制权限 (Dell 特定)
    ACTION=="add", SUBSYSTEM=="power_supply", KERNEL=="BAT0", RUN+="${pkgs.coreutils}/bin/chgrp power /sys/class/power_supply/BAT0/charge_control_end_threshold"
    ACTION=="add", SUBSYSTEM=="power_supply", KERNEL=="BAT0", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/power_supply/BAT0/charge_control_end_threshold"
  '';
}
