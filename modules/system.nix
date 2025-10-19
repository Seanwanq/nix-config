{
    pkgs,
    lib,
    username,
    ...
}: {
    # User related

    # Define a user account. Don't forget to set a password with 'passwd'
    users.users.${username} = {
        isNormalUser = true;
        description = username;
        extraGroups = ["networkmanager" "wheel" "audio" "video"];
        shell = pkgs.zsh;
    };

    # given the users in this list the right to specify additional substituters via:
    #    1. `nixConfig.substituers` in `flake.nix`
    #    2. command line args `--options substituers http://xxx`
    nix.settings.trusted-users = [username];

    # customise /etc/nix/nix.conf declaratively via `nix.settings`
    nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];

    substituters = [
      # cache mirror located in China
      # status: https://mirror.sjtu.edu.cn/
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
      # status: https://mirrors.ustc.edu.cn/status/
      # "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    builders-use-substitutes = true;
  };

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 1w";
  };

  # Optimise storage
  # you can also optimise the store manually via:
  #    nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  # Systemd 配置 - 减少关机时的等待时间
  systemd = {
    # 减少用户服务停止的超时时间
    user.extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
    
    # 系统级别的超时配置
    extraConfig = ''
      DefaultTimeoutStopSec=10s
      DefaultTimeoutStartSec=10s
    '';
    
    # 针对特定服务的超时配置
    services = {
      # NetworkManager-wait-online 可能导致启动延迟
      NetworkManager-wait-online.enable = false;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # 1Password configuration
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = ["${username}"];
  };

  # Configure 1Password to recognize custom browser wrappers for extension unlocking
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        google-chrome
        google-chrome-stable
        chrome
        firefox
        firefox-bin
        zen
      '';
      mode = "0755";
    };
  };

  # Set your time zone
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Fcitx5 input method for Chinese Pinyin
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk              # GTK integration
      fcitx5-chinese-addons   # Chinese Pinyin input support
      fcitx5-nord             # Nord color theme (optional)
    ];
  };

  # Environment variables for input method support
  # Critical for Electron apps (1Password, VSCode, etc.) to support fcitx5
  # Use mkForce to override fcitx5 module's default values
  environment.variables = {
    # Unset GTK_IM_MODULE for Wayland - use Wayland input method frontend instead
    GTK_IM_MODULE = lib.mkForce "";  # Empty string to unset
    QT_IM_MODULE = lib.mkForce "fcitx5";
    XMODIFIERS = lib.mkForce "@im=fcitx5";
    # Required for Wayland support in fcitx5
    INPUT_METHOD = lib.mkForce "fcitx5";
    # Additional environment variables for Electron apps
    GLFW_IM_MODULE = "ibus";  # Some Electron apps need this
    # 强制 Electron 应用使用 Wayland IME
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Flatpak support for installing applications from Flathub
  services.flatpak.enable = true;
  
  # Automatically add Flathub repository
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # 设置控制台字体大小(用于启动画面和 TTY)
  console = {
    font = "ter-v32n";  # Terminus 字体,32 像素高度
    packages = [ pkgs.terminus_font ];
    earlySetup = true;  # 尽早应用字体设置
  };

  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji

      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable-small/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
      nerd-fonts.symbols-only # symbols icon only
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
    ];
    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  programs.dconf.enable = true;

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };


  # List packages installed在系统级别
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    sysstat
    lm_sensors # for `sensors` command
    # minimal screen capture tool, used by i3 blur lock to take a screenshot
    # print screen key is also bound to this tool in i3 config
    scrot
    fastfetch
    xfce.thunar # xfce4's file manager
    wl-clipboard # Wayland 剪贴板工具(用于 VirtualBox 剪贴板共享)
    gnumake
    cmake
    gcc14
    
    # VSCode 依赖
    libsecret    # 用于密钥管理
    gnome-keyring # GNOME 密钥环
    
    # 1Password system authentication dependencies
    polkit_gnome  # PolKit authentication agent for GNOME
    gcr_4         # GCR library for crypto UI components

    # Battery and power management tools
    powertop
    brightnessctl  # Screen brightness control
    wev            # Wayland event viewer for debugging keybinds
    nixfmt-rfc-style
  ];

  programs.zsh.enable = true;


  # Enable sound with pipewire.
  # Sound configuration - PipeWire handles both ALSA and PulseAudio
  services.pulseaudio.enable = false;
  
  services.power-profiles-daemon = {
    enable = true;
  };
  
  # Security and authentication configuration for 1Password
  security.polkit.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  
  # PolKit authentication agent - required for 1Password system authentication
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
    });
  '';
  
  # Enable realtime priority for audio processes
  security.rtkit.enable = true;

  services = {
    dbus.packages = [pkgs.gcr];

    geoclue2.enable = true;
    
    # GNOME Keyring - VSCode 需要用于密码管理
    gnome.gnome-keyring.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # WirePlumber is the recommended session manager
      wireplumber.enable = true;
      
      # High-quality audio configuration
      extraConfig.pipewire."92-high-quality" = {
        context.properties = {
          # 高采样率以获得更好的音质
          default.clock.rate = 48000;
          default.clock.allowed-rates = [ 44100 48000 88200 96000 ];
          
          # 降低延迟，提高响应性
          default.clock.quantum = 256;
          default.clock.min-quantum = 256;
          default.clock.max-quantum = 512;
        };
      };
      
      # ALSA 高质量配置
      extraConfig.pipewire-pulse."92-pulse-high-quality" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "256/48000";
              pulse.default.req = "256/48000";
              pulse.max.req = "256/48000";
              pulse.min.quantum = "256/48000";
              pulse.max.quantum = "256/48000";
            };
          }
        ];
        stream.properties = {
          resample.quality = 10;  # 最高重采样质量 (0-10, 默认4)
        };
      };
    };

    udev.packages = with pkgs; [gnome-settings-daemon];
  };

}