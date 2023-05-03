{ config, pkgs, p4net, lib, nixpkgs-latest, ... }:
{
  # File for basic system configuration

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "btrfs" ];

    # Mount /tmp as tmpfs, but don't give it half of my RAM.
    tmpOnTmpfs = true;
    tmpOnTmpfsSize = "10%";
  };

  time.timeZone = "Europe/Warsaw";

  networking = {
    hostName = "transient";
    networkmanager.enable = true;

    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;

    firewall.enable = true;

    extraHosts = (builtins.readFile ./data/hosts) + ''
      0.0.0.0 reddit.com
      # 0.0.0.0 old.reddit.com
      0.0.0.0 www.reddit.com
    '';
  };

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
    nixpkgs-latest.legacyPackages.x86_64-linux.signal-desktop  # signal communicator
    nmap  # popular port scanner
    dig  # dns debugging tool
    todoist  # todoist cli
    cifs-utils  # for samba mounts
    cudatoolkit

    teamspeak_client
  ];
  environment.variables.EDITOR = "nvim";
  environment.variables.SUDO_EDITOR = "nvim";

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

  # Support for mdns
  services.avahi = {
    nssmdns = true;
    enable = true;
  };

  services.keybase = {
    enable = true;
  };

  # Local caching DNS server
  services.unbound = {
    enable = false;
    settings = {
      server = {
        interface = [ "127.0.0.1" ];
        cache-min-ttl = 3600;
      };
      forward-zone = [
        {
          name = ".";
          forward-tls-upstream = true;
          forward-addr = [ "1.1.1.1@853#cloudflare-dns.com" ];
        }
      ];
    };
  };

  # Enable FsTrim for SSD
  services.fstrim.enable = true;

  # Kot keeps turning off my laptop
  services.logind.extraConfig = ''
    # don't shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  # Enable nix flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Enable virtualisation solutions I use
  virtualisation.docker = {
    enable = true;
  };

  virtualisation.libvirtd = {
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
          "/dev/input/by-id/usb-2188_USB_OPTICAL_MOUSE-event-mouse",
          "/dev/input/by-id/usb-NOVATEK_USB_Keyboard-event-kbd",
          "/dev/input/by-id/usb-1267_PS_2+USB_Mouse-event-mouse",
          "/dev/input/by-id/usb-Primax_Dell_Wired_Multimedia_Keyboard-event-kbd",
          "/dev/input/by-id/usb-Dell_Computer_Corp_Dell_Universal_Receiver-if01-event-mouse"
        ]
        namespaces = []
      '';
    };
  };

  users.users.qemu-libvirtd.extraGroups = [ "input" ];

  xdg.portal.enable = true;
  services.flatpak.enable = true;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
