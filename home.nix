secrets: { config, pkgs, lib, ... }:
{
  xdg.configFile."sway/config" = {
    source = pkgs.writeText "config" (builtins.readFile ./dotfiles/swayconfig);
  };

  programs = {
    git = {
      enable = true;
      userName = "msm";
      userEmail = "msm@tailcall.net";
      extraConfig = {
        alias.lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%as)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        alias.lgg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%H%C(reset) - %C(bold green)(%ai)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        init.defaultBranch = "master";
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set EDITOR nvim
        any-nix-shell fish --info-right | source
      '';
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = builtins.readFile ./dotfiles/init.vim;
      plugins = with pkgs.vimPlugins; [
        vim-surround
        # coc-nvim coc-git coc-highlight coc-python coc-rls coc-vetur coc-vimtex coc-yaml coc-html coc-json # auto completion
        vim-nix
        # vim-easymotion
        # vim-sneak
        fzf-vim
        # nerdtree
        rainbow
      ];
    };

    tmux = {
      enable = true;
      terminal = "screen-256color";
      extraConfig = builtins.readFile ./dotfiles/tmux.conf;
    };

    firefox = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          settings = {
            # beacons allow sites to do requests when the tab is closed
            "beacon.enabled" = false;
            # don't hide tabs while fullscreen
            "browser.fullscreen.autohide" = false;
            # disable <a> ping feature
            "browser.send_pings" = false;
            # disable geolocation
            "geo.enabled" = false;
            # who thought this is a good idea
            "dom.serviceWorkers.enabled" = false;
            # no, I don't want your notifications
            "dom.push.enabled" = false;
            # show the real compact mode
            "browser.compactmode.show" = true;
          };
        };
      };
      extensions =
        with pkgs.nur.repos.rycee.firefox-addons; [
          # vim-like bindings for firefox
          vimium
          # autoredirect to https
          https-everywhere
          # block unnecessary web content
          ublock-origin
          # block tracking content (and save bandwidth)
          decentraleyes
        ];
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = { };
    };

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        haskell.haskell
        justusadam.language-haskell
      ];
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  services = {
    mpd = {
      enable = true;
    };

    spotifyd = {
      enable = true;
      settings = {
        global = {
          username = "msm2e4d534d";
          password = secrets.spotifypassword;
          device_name = "transient";
        };
      };
    };
  };

  home.packages =
    [ (import ./scripts/lastd.nix { pkgs = pkgs; }) ] ++
    [
      pkgs.fd
      pkgs.cached-nix-shell
      pkgs.keepassxc
      pkgs.pavucontrol
      pkgs.tor-browser-bundle-bin
    ];

  home.sessionVariables.EDITOR = "nvim";
}

