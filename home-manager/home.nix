{ buildFirefoxXpiAddon, config, pkgs, lib, secrets, nixpkgs-latest, exts, ... }:
{
  xdg.configFile."sway/config" = {
    source = pkgs.writeText "config" (builtins.readFile ./dotfiles/sway/config);
  };

  xdg.configFile."alacritty/alacritty.yml" = {
    source = pkgs.writeText "config" (builtins.readFile ./dotfiles/alacritty/alacritty.yml);
  };

  xdg.configFile."matterhorn/config.ini" = {
    source = pkgs.writeText "config" (builtins.readFile ./dotfiles/matterhorn/config.ini);
  };

  imports = [
    ./modules/terminal.nix
    ./modules/fish-advanced.nix
    ./modules/nvim.nix
    ./modules/firefox.nix
    ./modules/gpg.nix
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      haskell.haskell
      justusadam.language-haskell
    ];
  };

  services.mpd = {
    enable = true;
  };

  services.swayidle = {
    enable = true;
  };

  home.packages =
    [ (import ./scripts/lastd.nix pkgs) ] ++
    [ (import ./gsocket.nix pkgs) ] ++
    (with pkgs; [
      any-nix-shell
      fd
      keepassxc
      pavucontrol
      tor-browser-bundle-bin
      xxd
      file
      evince
      nur.repos.plabadens.diskgraph
      # nur.repos.genesis.frida-tools
      joplin-desktop
      tcpdump
      wget
      wireshark
      usbutils
      kubectl
      colordiff
      aerc  # email client
      nodejs
      nixpkgs-latest.legacyPackages.x86_64-linux.matterhorn  # matterhorn with my patches

      # CTF and work related stuff
      ghidra-bin
      bintools
      # python38Packages.malduck
      python38Packages.pycrypto
      taskwarrior
      dino
      # quiterss broken by qt
      unrar-wrapper
      scrcpy
      usb-modeswitch
      meld
      (pass.withExtensions (exts: [ exts.pass-otp ]))
      ripgrep
      gh
      pinta  # drawing program, used mostly for memes
      sxiv  # image viewer
      mpv  # sound player
      libreoffice
    ]);

  home.sessionVariables.EDITOR = "nvim";

  home.stateVersion = "21.11";
}

