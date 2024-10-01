{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.

  boot = {
    plymouth = {
      enable = true;
      theme = "optimus";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "optimus" ];
        })
      ];
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "nvidia-drm.fbdev=1"
      "nvidia-drm.modeset=1"
    ];
    blacklistedKernelModules = [
    "nouveau"
  ];

  loader.timeout = 0;
  loader.systemd-boot.enable = true;
  loader.efi.canTouchEfiVariables = true;
  kernelPackages = pkgs.linuxPackages_latest;
};


  networking.hostName = "codingewer";
  #networking.wireless.enable = true;  
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  #Ollama
  services.ollama = {
  enable = true;
  acceleration = "cuda";
  };


  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "tr";
    variant = "";
  };
  services.power-profiles-daemon.enable = false;
  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 70;
       STOP_CHARGE_THRESH_BAT0 = 1;
       START_CHARGE_THRESH_BAT1 = 75;
       STOP_CHARGE_THRESH_BAT1 = 80;
       USB_AUTOSUSPEND=1;
      };
};
  # Configure console keymap
  console.keyMap = "trq";

  services.printing.enable = true;
  
  #bluetooth
  hardware.bluetooth.enable = true;

  hardware.opentabletdriver.enable = true;
 

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      pkgs.mesa
       pkgs.mesa_drivers
      pkgs.libva
      pkgs.libvdpau-va-gl
      vulkan-loader
    ];
  };
 
  services.xserver.videoDrivers = ["nvidia" "amdgpu"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true; 
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    prime = {
	offload = {
		enable = true;
		enableOffloadCmd = true;
	};
	nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:5:0:0";
   };
#   package = config.boot.kernelPackages.nvidiaPackages.stable;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver{
    version = "550.107.02";
   sha256_64bit = "sha256-+XwcpN8wYCjYjHrtYx+oBhtVxXxMI02FO1ddjM5sAWg=";
    sha256_aarch64 = "sha256-mVEeFWHOFyhl3TGx1xy5EhnIS/nRMooQ3+LdyGe69TQ=";
    openSha256 = "sha256-Po+pASZdBaNDeu5h8sgYgP9YyFAm9ywf/8iyyAaLm+w=";
    settingsSha256 = "sha256-WFZhQZB6zL9d5MUChl2kCKQ1q9SgD0JlP4CMXEwp2jE=";
    persistencedSha256 = "sha256-Vz33gNYapQ4++hMqH3zBB4MyjxLxwasvLzUJsCcyY4k=";
   # version = "560.35.03";
   ## sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
   # sha256_aarch64 = "sha256-s8ZAVKvRNXpjxRYqM3E5oss5FdqW+tv1qQC2pDjfG+s=";
   # openSha256 = "sha256-/32Zf0dKrofTmPZ3Ratw4vDM7B+OgpC4p7s+RHUjCrg=";
   # settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
   # persistencedSha256 = "sha256-E2J2wYYyRu7Kc3MMZz/8ZIemcZg68rkzvqEwFAL3fFs=";
    };
  };
 
  
  # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
#  services.xserver.libinput.enable = true;
 
 users.users.codi = {
    isNormalUser = true;
    description = "codi";
    extraGroups = [ "networkmanager" "wheel" "video" "render" "kvm" "adbusers" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };



  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  gamescopeSession.enable = true; 
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
   };
  # Install firefox.
  programs.firefox.enable = true;
  programs.gamemode.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  programs.hyprland.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  nano
  kitty
  waybar
  blueman
  hypridle
  hyprpaper
  hyprpicker
  hyprshot
  hyprlang
  hyprlock
  nwg-drawer
  nwg-bar
  swaynotificationcenter
  networkmanagerapplet
  vscode
  heroic
  wineWowPackages.stable
  protonup
  mangohud
  gedit
  go
  nodejs
  yarn
  fish
  fastfetch
  ascii-image-converter
  pciutils
  fuzzel
  git
  swayosd
  xfce.thunar
  gnome.gnome-tweaks
  fuzzel
  spotify
  peaclock
  cmatrix
  cavalier
  gcc
  clang
  cargo
  cmake
  gnumake
  wofi
  colorls
  clipman
  wl-clipboard
  kdePackages.sddm-kcm
  lxqt.lxqt-policykit
  papirus-icon-theme
  font-manager
  sassc
  libinput
  busybox
  pavucontrol
  htop
  nvtopPackages.full
  xournalpp
  inkscape
  blender
  pkgs.android-studio
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?

}

