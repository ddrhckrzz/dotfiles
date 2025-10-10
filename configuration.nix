# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ddrhckrzz-nixos" ; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_PH.UTF-8";

  i18n.supportedLocales = ["en_PH.UTF-8/UTF-8"];

  i18n.extraLocaleSettings = {
   LC_ALL = "en_PH.UTF-8";
  };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "ph";
  #   variant = "";
  # };

  # Enable KDE Plasma 6.
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };

  # Enable KDE PIM (Plasma 6)
  programs.kde-pim.enable = true;
  
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # Integrated AMD GPU
    amdgpuBusId = "PCI:5:0:0";
    # Discrete NVIDIA GPU...??
    nvidiaBusId = "PCI:1:0:0";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Editing some systemd settings
  systemd.tpm2.enable = false;
  boot.initrd.systemd.tpm2.enable = false;
  systemd.settings.Manager = {
    DefaultTimeoutStartSec = "20s";
    DefaultTimeoutStopSec = "20s";
    DefaultDeviceTimeoutSec = "20s";
    TimeoutStartSec = "20s";
    TimeoutStopSec = "20s";
    RuntimeWatchdogSec = "10s";
    RebootWatchdogSec = "20s";
    KExecWatchdogSec = "10s";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ddrhckrzz = {
    isNormalUser = true;
    description = "Andrei Ernest G. Martillo";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      thunderbird
    ];
  };

  fonts.packages = with pkgs; [
    monocraft
    dejavu_fonts
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  fonts.fontDir.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vscode.fhs 				        # VSCode with extension support
    wget                      # The non-interactive network downloader
    git	                    	# Version Control
    snapshot			            # Screenshot lol
    direnv                    # Shell Extension that manages the environment
    neofetch                  # Fetches system information and displays it in the terminal
    htop                      # Interactive process viewer
    zoxide                    # Smart directory navigation tool
    alacritty                 # Alternative Terminal
    devenv                    # Development Environment for NixOS
    kdePackages.bluedevil     # KDE Bluetooth for Plasma 5
    kdePackages.bluez-qt      # Qt wrapper for Bluez 5 DBus API

    # Dependencies in general
    pkgs.temurin-bin		    	# Temurin OpenJDK 21 LTS
    pkgs.temurin-jre-bin-8		# Temurin JRE 8
    pkgs.temurin-jre-bin-17		# Temurin JRE 17
    zulu25                    # Azul Zulu OpenJDK 25
    maven                     # Apache Maven for Java projects
    nss_latest                # Latest NSS (Network Security Services) for Firefox
    (pkgs.rWrapper.override{ 
      packages = with pkgs.rPackages; [ # R with R packages
        rmarkdown
        rlang
        ggplot2
        downloader
        dplyr
        tidyr
        xts
      ];
    })
    (pkgs.rstudioWrapper.override{ 
      packages = with pkgs.rPackages; [ # RStudio with R packages
        rmarkdown
        knitr
        rlang
        dplyr
        ggplot2
        tidyr
        readr
        stringr
        forcats
        xts
        shiny
        learnr
        rstudioapi
        downloader
      ];
    })
    pandoc                    # Universal document converter
    pkgs.mars-mips            # MARS IDE for MIPS assembly language
    nasm                      # Netwide Assembler for x86 architecture
    fontconfig                # Font configuration and customization library

    # Wine stuff
    wineWowPackages.waylandFull
    winetricks

    # Hacking stuff
    inputs.ctf-tools.packages."${system}".default # CTF Tools
    exiftool
    p7zip
    binwalk
    sleuthkit
    steghide

    # Office
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
    
    # Desktop Apps
    pkgs.vesktop 			        # Discord
    pkgs.gparted			        # Partition Manager
    pkgs.prismlauncher		  	# Prism Launcher for Minecraft
    hardinfo2                 # System information and benchmarks for Linux systems
    haruna                    # Open source video player built with Qt/QML and libmpv
    wayland-utils             # Wayland utilities
    wl-clipboard              # Command-line copy/paste utilities for Wayland
    kdePackages.kcalc         # Calculator
    kdePackages.kolourpaint   # Easy-to-use paint program
    kdePackages.ksystemlog    # KDE SystemLog Application
    kdePackages.sddm-kcm      # Configuration module for SDDM
    kdiff3                    # Compares and merges 2 or 3 files or directories
    kdePackages.kdepim-addons # KDE PIM Addons
    kdePackages.eventviews    # KDE PIM Event Views
    kdePackages.korganizer    # KDE Organizational Assistant
    inputs.zen-browser.packages."${system}".default # Zen Browser
    zeal                      # Offline documentation browser
    kdePackages.kio-gdrive    # Google Drive integration for KDE
    audacity                  # Audio Editor
    jetbrains.idea-community-bin # JetBrains IntelliJ IDEA Community Edition
  ];
  
  # Enable and Configure Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Allow installing of App Images
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Add some swap
  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024; # 16GB Swap
  }];

  # Power management
  powerManagement.enable = true;

  # Enable Hibernation
  boot.kernelParams = [ "resume_offset=27885568" "mem_sleep_default=deep" ];
  boot.resumeDevice = "/dev/disk/by-uuid/38227467-d7d3-4799-b3c6-85acb06394ad";

  services.power-profiles-daemon.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate"; # Suspend first then hibernate when lid is closed
    HandlePowerKey = "hibernate"; # Hibernate when power button is pressed
    HandlePowerKeyLongPress = "poweroff"; # Power off when power button is long-pressed
    HandleLidSwitchDocked = "ignore"; # Do nothing when lid is closed and external monitor is connected
  };

  # Define time delay for hibernation
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
  '';

  # Garbage collect stuff older than 10 days
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };
  
  # Enable Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatically upgrade NixOS
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable Tailscale servie.
  services.tailscale = {
    enable = true;
    # Set the Tailscale routing config here
    useRoutingFeatures = "both";
  };

  networking.firewall = {
    enable = true; # Enable the firewall
    allowedTCPPorts = [ 22 80 443 ]; # Open ports for SSH, HTTP, and HTTPS
    allowedUDPPorts = [ 53 ]; # Open port for DNS

    # You can also specify allowed IPs or networks.
    # allowedIPs = [ " " ];

    # Setting up UDP Ranges
    # allowedUDPPortsRanges = [
    #   { from = 4000; to = 4007; }
    #   { from = 8000; to = 8010; }
    # ];

  };

  # Enable Virtualization with libvirtd and virt-manager
  programs.virt-manager.enable = true; # Enable virt-manager
  users.groups.libvirtd.members = [ "ddrhckrzz" ];
  virtualisation.libvirtd.enable = true; # Enable libvirtd service
  virtualisation.spiceUSBRedirection.enable = true; # Enable SPICE USB Redirection

  services.evremap = {
    enable = true; # Enable evremap service
    settings = {
      device_name = "AT Translated Set 2 keyboard"; # Specify the device name to remap
      phys = "isa0060/serio0/input0"; # Physical device to listen to
      # Remap Settings
      remap = [
        {
          input = ["KEY_CAPSLOCK"];
          output = ["KEY_ESC"]; # Remap Caps Lock to ESC
        }
        {
          input = [
            "KEY_LEFTSHIFT"
            "KEY_RIGHTSHIFT"
          ];
          output = ["KEY_CAPSLOCK"]; # Remap L+RShift to Caps Lock
        }
      ];
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
