{ config, inputs, ... }:
{
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = false;
      vimAlias = true;
      options = {
        tabstop = 4;
      };
      lsp = {
        enable = true;
      };
      languages = {
        nix.enable = true;
        python.enable = true;
        go.enable = true;
      };
      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
        registers = "unnamedplus";
      };
    };
  };
}
