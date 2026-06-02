{ config, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    policies = {
      DisableAccounts = true;
      DisableAppUpdate = true;
      DisableFirefoxAccounts = true;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;
      GenerativeAI.Enabled = false;
      Preferences = {
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.startup.page" = 3;
      };
      SearchEngines.Default = "DuckDuckGo";
      SkipTermsOfUse = true;
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        FirefoxLabs = false;
      };
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
