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
      lsp = {
        enable = true;
      };
      languages = {
        nix.enable = true;
      };
    };
  };
}
