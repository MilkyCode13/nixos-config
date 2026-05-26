{ config, ... }:
{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    policies = {
      DisableTelemetry = true;
      SearchEngines.Default = "DuckDuckGo";
      SkipTermsOfUse = true;
    };
  };

  home.persistence."/persistent" = {
    directories = [
      ".config/mozilla"
    ];
  };
}
