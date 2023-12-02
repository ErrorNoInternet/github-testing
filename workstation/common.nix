{
  self,
  lib,
  pkgs,
  ...
}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    supportedFilesystems = ["ntfs"];
    kernel.sysctl = {
      "kernel.sysrq" = 1;
    };
  };
  networking = {
    firewall.enable = false;
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
  };
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };
  services.xserver = {
    enable = true;
    excludePackages = [pkgs.xterm];
    displayManager = {
      lightdm.enable = false;
      sddm = {
        enable = true;
        theme = "${self.packages.${pkgs.system}.sddm-theme}";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtgraphicaleffects

    cryptsetup
    curl
    file
    git
    killall
    neovim
    pulseaudio
    ripgrep
    unzip
    vim
    wget
    xdg-user-dirs
  ];
  programs.dconf.enable = true;
  programs.light.enable = true;
  programs.gnupg.agent.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.openssh.enable = true;

  programs.neovim.defaultEditor = true;
  security.pam.services.swaylock = {};
  services.logind.lidSwitch = "ignore";
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      source-han-sans
      source-han-serif
      twitter-color-emoji
    ];
    fontconfig = {
      defaultFonts = {
        serif = [
          "JetBrainsMono Nerd Font"
          "Noto Serif CJK SC"
        ];
        sansSerif = [
          "JetBrainsMono Nerd Font"
          "Noto Sans CJK SC"
        ];
        monospace = ["JetBrainsMono Nerd Font"];
        emoji = ["Twitter Color Emoji"];
      };
    };
  };

  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=
    TEMPLATES=
    PUBLICSHARE=
    DOCUMENTS=
    MUSIC=
    PICTURES=
    VIDEOS=
  '';
  users.users.ryan = {
    initialPassword = "snowflake";
    isNormalUser = true;
    extraGroups = ["wheel" "video"];
  };

  environment.etc."current-nixos".source = ./.;
  system.stateVersion = "23.05";
}
