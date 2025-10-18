{ config, pkgs, lib, ... }:

{
  # 使用 Home Manager 的 rclone 模块
  programs.rclone = {
    enable = true;
  };

  # rclone 配置文件由用户手动管理
  # 首次运行: rclone config
  # 配置会保存在 ~/.config/rclone/rclone.conf
  # 
  # 该文件不由 Nix 管理，这样可以：
  # 1. 避免将密钥提交到 Git
  # 2. token 可以自动刷新
  # 3. 跨机器同步时只需复制 ~/.config/rclone/rclone.conf

  # 创建 systemd 服务来挂载 OneDrive
  systemd.user.services.rclone-onedrive = {
    Unit = {
      Description = "RClone mount for OneDrive";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "notify";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/OneDrive";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount onedrive: %h/OneDrive \
          --vfs-cache-mode writes \
          --vfs-cache-max-age 24h \
          --vfs-read-chunk-size 128M \
          --vfs-read-chunk-size-limit off \
          --buffer-size 64M \
          --use-mmap \
          --dir-cache-time 12h \
          --poll-interval 15s
      '';
      ExecStop = "${pkgs.fuse}/bin/fusermount -u %h/OneDrive";
      Restart = "on-failure";
      RestartSec = "10s";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
