# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

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

  # Enable KDE Plasma 6.
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };

  # Enable KDE PIM (Plasma 6)
  programs.kde-pim.enable = true;

  # MAKE KDE PLASMA FASTER!!!!!!! /// let's disable this for now

  # nixpkgs.overlays = lib.singleton (final: prev: {
  #   kdePackages = prev.kdePackages // {
  #     plasma-workspace = let

  #       # the package we want to override
  #       basePkg = prev.kdePackages.plasma-workspace;

  #       # a helper package that merges all the XDG_DATA_DIRS into a single directory
  #       xdgdataPkg = pkgs.stdenv.mkDerivation {
  #         name = "${basePkg.name}-xdgdata";
  #         buildInputs = [ basePkg ];
  #         dontUnpack = true;
  #         dontFixup = true;
  #         dontWrapQtApps = true;
  #         installPhase = ''
  #           mkdir -p $out/share
  #           ( IFS=:
  #             for DIR in $XDG_DATA_DIRS; do
  #               if [[ -d "$DIR" ]]; then
  #                 cp -r $DIR/. $out/share/
  #                 chmod -R u+w $out/share
  #               fi
  #             done
  #           )
  #         '';
  #       };

  #       # undo the XDG_DATA_DIRS injection that is usually done in the qt wrapper
  #       # script and instead inject the path of the above helper package
  #       derivedPkg = basePkg.overrideAttrs {
  #         preFixup = ''
  #           for index in "''${!qtWrapperArgs[@]}"; do
  #             if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
  #               unset -v "qtWrapperArgs[$((index+0))]"
  #               unset -v "qtWrapperArgs[$((index+1))]"
  #               unset -v "qtWrapperArgs[$((index+2))]"
  #               unset -v "qtWrapperArgs[$((index+3))]"
  #             fi
  #           done
  #           qtWrapperArgs=("''${qtWrapperArgs[@]}")
  #           qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
  #           qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
  #         '';
  #       };

  #     in derivedPkg;
  #   };
  # });
  
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

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
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
    extraGroups = [ "networkmanager" "wheel" "kvd" "adbusers" ];
    packages = with pkgs; [
      thunderbird
      gimp                      # Image Editor
      audacity                  # Audio Editor

      # School Stuff
      pencil                    # GUI prototyping tool

      # Office
      libreoffice-qt-fresh
      hunspell
      hunspellDicts.en_US

      # Desktop Apps
      pkgs.vesktop 			        # Discord
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
      pkgs.gparted			        # Partition Manager
      pkgs.prismlauncher		  	# Prism Launcher for Minecraft
      hardinfo2                 # System information and benchmarks for Linux systems
      haruna                    # Open source video player built with Qt/QML and libmpv
      jetbrains.idea-oss        # JetBrains IntelliJ IDEA Community Edition
      protonup-qt               # GUI Proton Updater
      inputs.zen-browser.packages."${system}".default # Zen Browser
      zeal                      # Offline documentation browser
      wl-clipboard              # Command-line copy/paste utilities for Wayland
      kdePackages.kcalc         # Calculator
      kdePackages.kolourpaint   # Easy-to-use paint program
      kdePackages.ksystemlog    # KDE SystemLog Application
      kdePackages.sddm-kcm      # Configuration module for SDDM
      kdiff3                    # Compares and merges 2 or 3 files or directories
      kdePackages.kdepim-addons # KDE PIM Addons
      kdePackages.eventviews    # KDE PIM Event Views
      kdePackages.korganizer    # KDE Organizational Assistant
      kdePackages.kio-gdrive    # Google Drive integration for KDE
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
    fastfetch                 # Fast system information tool written in Rust
    htop                      # Interactive process viewer
    zoxide                    # Smart directory navigation tool
    alacritty                 # Alternative Terminal
    devenv                    # Development Environment for NixOS
    kdePackages.bluedevil     # KDE Bluetooth for Plasma 5
    kdePackages.bluez-qt      # Qt wrapper for Bluez 5 DBus API
    caligula                  # User-friendly, lightweight TUI for disk imaging
    killall                   # Kill processes by name

    # Dependencies in general
    pkgs.temurin-bin		    	# Temurin OpenJDK 21 LTS
    pkgs.temurin-jre-bin-8		# Temurin JRE 8
    pkgs.temurin-jre-bin-17		# Temurin JRE 17
    zulu25                    # Azul Zulu OpenJDK 25
    maven                     # Apache Maven for Java projects
    pandoc                    # Universal document converter
    android-studio            # Android Studio for Android Development
    postman                   # Postman
    jadx                      # Dex to Java decompiler
    unrar                     # RAR file extractor
    (texlive.combine {
      inherit (texlive) scheme-medium todonotes;
    })
    android-tools             # Android SDK Platform Tools (adb, fastboot, etc.)

    # Wine stuff
    wineWowPackages.waylandFull
    winetricks

    # Hacking stuff
    # MOVED: Check Specific CTF Tools in the respective Coding Environment Folder
    exiftool
    p7zip
    binwalk
    sleuthkit
    steghide

    #other stuff
    wayland-utils             # Wayland utilities
  ];
  
  # Enable and Configure Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;

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
