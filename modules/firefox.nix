{
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      SearchEngines.Default = "DuckDuckGo";
      SkipTermsOfUse = true;
    };
  };
}
