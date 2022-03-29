{ config, pkgs, p4net, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "btrfs" ];

    # Mount /tmp as tmpfs, but don't give it half of my RAM.
    tmpOnTmpfs = true;
    tmpOnTmpfsSize = "10%";
  };

  boot = {
    # VFIO: disable nvidia and nouveau drives
    blacklistedKernelModules = [ "nvidia" "nouveau" ];

    # kernel modules required for VFIO
    kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];

    extraModprobeConfig =
       let nvidia_pci_id = "10de:1fb8";
       in "options vfio-pci ids=${nvidia_pci_id}";
  };

  time.timeZone = "Europe/Warsaw";

  networking = {
    hostName = "transient";
    networkmanager.enable = true;

    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;

    firewall.enable = true;

    extraHosts = (builtins.readFile ./data/hosts);
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;

  users.users.msm = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "audio" "libvirtd" ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    any-nix-shell  # i want fish, not dirty bash
    bat  # better cat
    virt-manager  # manage virtual machines
    p7zip
    python3
    borgbackup  # automated backup
    bubblewrap  # run programs in a jail
    sshfs  # mount ssh directories locally
    docker-compose  # docker-compose, duh
    htop  # better top
    imv  # wayland-native image viewer
    signal-desktop  # signal communicator
  ];
  environment.variables.EDITOR = "nvim";
  environment.variables.SUDO_EDITOR = "nvim";

  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && sway
  '';

  fonts.fonts = [ pkgs.font-awesome ];

  security.sudo.execWheelOnly = true;
  security.sudo.extraRules = [
    {
      users = [ "msm" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      # Lock screen
      swaylock
      # Copy to clipboard
      wl-clipboard
      # Notification deamon
      mako
      # Used by some mako commands
      jq
      # The default terminal
      alacritty
      # Wayland-native launcher
      wofi
      # Pretty wayland bar
      waybar
      # For printscreen key
      slurp
      # For printscreen key
      grim
      # Smart window switcher for sway.
      # For some reason doesn't work right now?
      swayr
      # Auto screenlock
      swayidle
    ];
  };

  # Don't really remember why this is enabled.
  programs.dconf.enable = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };
  services.getty.autologinUser = "msm";

  # Support for mdns
  services.avahi = {
    nssmdns = true;
    enable = true;
  };

  services.p4net = {
    enable = true;
    privateKeyFile = "/home/msm/data/wg/p4net.priv";
    ips = "198.18.70.2/24";
    listenPort = 51820;
    peers = [{
      publicKey = "ALxno1mlbRdMJ34n0eQXeLb6lukDBrC39X9qZJz3rSU=";
      allowedIPs = [ "198.18.70.0/24" ];
      endpoint = "135.181.113.20:51820";
    }];
  };

  # Local caching DNS server
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" ];
        cache-min-ttl = 3600;
      };
      forward-zone = [{
        name = ".";
        
        forward-tls-upstream = true;
	      forward-first = false;
        forward-addr = [ "1.1.1.1@853#cloudflare-dns.com" ];
      }];
    };
  };

  # Enable FsTrim for SSD
  services.fstrim.enable = true;

  # Enable nix flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Enable virtualisation solutions I use
  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf = {
          enable = true;
        };
        # ACLs for input devices.
        verbatimConfig = ''
          cgroup_device_acl = [
            "/dev/null",
            "/dev/full",
            "/dev/zero",
            "/dev/random",
            "/dev/urandom",
            "/dev/ptmx",
            "/dev/kvm",
            "/dev/kqemu",
            "/dev/rtc",
            "/dev/hpet",
            "/dev/input/by-id/usb-YICHIP_Wireless_Device-if01-event-mouse",
            "/dev/input/by-id/usb-NOVATEK_USB_Keyboard-event-kbd",
          ]
          namespaces = []
        '';
      };
    };
  };
  users.users.qemu-libvirtd.extraGroups = [ "input" ];
  users.extraGroups.vboxusers.members = [ "msm" ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
