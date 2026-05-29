{ config, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    policies = {
      DisableTelemetry = true;
      SearchEngines.Default = "DuckDuckGo";
      SkipTermsOfUse = true;
    };
    profiles = {
      default = {
        extensions = {
          force = true;
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
          ];
        };
      };
    };
  };

  home.persistence."/persistent" = {
    directories = [
      ".config/mozilla"
    ];
  };

  stylix.targets.firefox = {
    profileNames = [ "default" ];
    colorTheme.enable = true;
  };
}
