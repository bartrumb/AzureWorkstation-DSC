Configuration LCMConfiguration
{
Node "localhost"
    {
        LocalConfigurationManager
        {
            ConfigurationMode = "ApplyAndAutoCorrect"
            ActionAfterReboot = "ContinueConfiguration"
            RefreshFrequencyMins = 30
            ConfigurationModeFrequencyMins = 15
            RefreshMode = "PUSH"
            RebootNodeIfNeeded = $true
        }

    }
}
LCMConfiguration