{ lib, pkgs, nixpkgs-latest, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.readFile ../dotfiles/init.vim;
    plugins = (with pkgs.vimPlugins; [
      # this is pretty heavy, but my XXI century machine can handle it
      # nvim-treesitter.withAllGrammars
      # coc plugins for various languages I like
      coc-nvim coc-git coc-highlight coc-python coc-pyright coc-rls coc-vetur coc-vimtex coc-yaml coc-html coc-json coc-clangd
      # tiny feature for handling brackets etc
      vim-surround
      # support for the nix language ofc
      vim-nix
      # fzf integrations
      fzf-vim
      # yay rainbows
      rainbow
      ## vim-easymotion
      ## vim-sneak
      ## nerdtree
      vim-rooter
    ]);
  };

  home.packages = with pkgs; [
    clang-tools
  ];
}
