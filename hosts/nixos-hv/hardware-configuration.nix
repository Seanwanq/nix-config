# Hyper-V 第 2 代虚拟机的硬件配置。
# 按磁盘卷标挂载，安装时分区需使用以下卷标：
#   /dev/sda1  FAT32  label=boot   -> /boot
#   /dev/sda2  ext4   label=nixos  -> /
# 也可以用安装时 `nixos-generate-config` 生成的文件替换本文件。
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # 第 2 代虚拟机的磁盘挂在 VMBus SCSI 控制器上
  boot.initrd.availableKernelModules = [ "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "hv_vmbus" "hv_storvsc" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  # 4GB 交换文件，避免大型构建时内存不足
  swapDevices = [ { device = "/var/lib/swapfile"; size = 4 * 1024; } ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
