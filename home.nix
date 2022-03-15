{ buildFirefoxXpiAddon, config, pkgs, lib, secrets, ... }:
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

    firefox =
      let
        checker-plus-for-calendar = pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon {
          pname = "wtf";
          version = "29.0.1";
          addonId = "checkerplusforgooglecalendar@jasonsavard.com";
          url = "https://addons.mozilla.org/firefox/downloads/file/3906906/checker_plus_for_google_calendartm-29.0.2-fx.xpi";
          sha256 = "b7988d0c0ea5177ec3235e2eaa72d0081a4975c5a7dc12c99f2c3ef377a21efd";
          meta = with lib;
          {
            homepage = "//jasonsavard.com?ref=homepage_url&ext=calendar";
            description = "Calendar checker";
            license = licenses.mit;
            platforms = platforms.all;
          };
        };
      in {
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
            localcdn
            # calendar checker plus
            checker-plus-for-calendar
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
      pkgs.keepassxc
      pkgs.pavucontrol
      pkgs.tor-browser-bundle-bin
      pkgs.xxd
      pkgs.file
      pkgs.evince
      pkgs.nur.repos.plabadens.diskgraph
      pkgs.joplin-desktop
      pkgs.tcpdump
      pkgs.wget
    ];

  home.sessionVariables.EDITOR = "nvim";
}

