# Load Providers
set-executionpolicy -ExecutionPolicy Unrestricted -Force
Install-PackageProvider chocolatey –Force
Register-PackageSource -Force -name chocolatey -ProviderName Chocolatey -Trusted -Location http://chocolatey.org/api/v2/
Register-PackageSource -Force -name nuget -ProviderName NuGet -Trusted -Location https://www.nuget.org/api/v2/
(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1
Invoke-Expression -Command "choco feature enable -n=allowGlobalConfirmation"
Invoke-Expression -Command "choco feature enable -n=allowEmptyChecksumsSecure"
Invoke-Expression -Command "choco feature enable -n=allowEmptyChecksums"


Invoke-Expression -Command "cup all"
Invoke-Expression -Command "cinst webpicmd /y"
Invoke-Expression -Command "cinst boxstarter /y"
Invoke-Expression -Command "cinst line /y --allowemptychecksumssecure --allowemptychecksums --allowemptychecksum --params'' --ia''"

https://scdn.line-apps.com/client/win/new/LineInst.exe

# Confirm Providers
#get-packagesource

# Trust PowerShell Gallery
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -SourceLocation https://www.powershellgallery.com/api/v2/

# Confirm Repository Trust
#Get-PSRepository

# Install PowerShell Modules
find-module -name PackageManagementProviderResource -Repository PSGallery | Install-module -Force
find-module -name cChoco -Repository PSGallery | Install-module -Force
find-module -name xPowerShellExecutionPolicy -Repository PSGallery | Install-module -Force
find-module -name xPendingReboot -Repository PSGallery | Install-module -Force


.\LocalConfig.ps1
Set-DSCLocalConfigurationManager -Path ".\LCMConfiguration"
Get-DSCLocalConfigurationManager 
Configuration AzureAdminWorkstation
{
   Import-DscResource -Module cChoco  
   Import-DSCResource -Module xPowerShellExecutionPolicy
   Import-DscResource -Module PackageManagementProviderResource
   Import-DsCResource -Module xPendingReboot

   Node "localhost"
   {
      LocalConfigurationManager
      {
          DebugMode = 'ForceModuleImport'       
      }
      xPowerShellExecutionPolicy ExecutionPolicy
      {
        ExecutionPolicy = "bypass"
      }

      PSModule AzureAutomationRunbookUtilities
      {
        Ensure            = "present" 
        Name              = "AzureAutomationRunbookUtilities"
        Repository        = "PSGallery"
        InstallationPolicy="trusted"     
      } 

      PSModule AzureAD
      {
        Ensure            = "present" 
        Name              = "AzureAD"
        Repository        = "PSGallery"
        InstallationPolicy="trusted"     
      } 

      PSModule AzureDiagnosticsAndLogAnalytics
      {
        Ensure            = "present" 
        Name              = "AzureDiagnosticsAndLogAnalytics"
        Repository        = "PSGallery"
        InstallationPolicy="trusted"     
      } 


      PSModule PSScriptAnalyzer
      {
        Ensure            = "present" 
        Name              = "PSScriptAnalyzer"
        Repository        = "PSGallery"
        InstallationPolicy="trusted"     
      } 


      cChocoInstaller installChoco
      {
        InstallDir = "c:\choco"
      }

      cChocoPackageInstallerSet installSomeStuff
      {
         Ensure = 'Present'
         Name = @(
            "vcredist2008"
            "vcredist2010"
            "vcredist2012"
            "vcredist2013"
            "vcredist2015" 
            "sccmtoolkit" 
            "adobereader"
            "notepadplusplus.install"
            "sysinternals"
            "azcopy"
            "microsoftazurestorageexplorer"
            "poshgit"
            "visualstudiocode"
            "pscx"
            "awscli"
            "windowsazurelibsfornet"
            "firefox"
            "lastpass"
            "carbon"
            "SourceTree"
            "winrar"     
		)
         DependsOn = "[cChocoInstaller]installChoco"
      }     

    # Reboot if pending
    xPendingReboot RebootCheck1
    {
    Name = "RebootCheck1"
    SkipPendingFileRename = $True
    SkipCcmClientSDK = $True
    }

      cChocoPackageInstaller webpicmd
      {
        Name        = "webpicmd"
        DependsOn   = "[cChocoInstaller]installChoco"
        AutoUpgrade = $True
      }

		#Install Microsoft Azure Cross-platform Command Line Tools
		cChocoPackageInstaller WindowsAzureXPlatCLI
		{
			Ensure = "Present"
			Name = "Microsoft Azure Command Line Tools"
            AutoUpgrade = $True
            chocoParams = "-source webpi"
		}


    # Reboot if pending
    xPendingReboot RebootCheck2
    {
    Name = "RebootCheck2"
    SkipPendingFileRename = $True
    SkipCcmClientSDK = $True
    }

		#Install Windows Azure Pack - PowerShell API - 2013
		cChocoPackageInstaller  WAP_PowerShellAPI
		{
			Ensure = "Present"
			Name = "WAP_PowerShellAPI"
            AutoUpgrade = $True
            chocoParams = "-source webpi"
		}

    # Reboot if pending
    xPendingReboot RebootCheck3
    {
    Name = "RebootCheck3"
    SkipPendingFileRename = $True
    SkipCcmClientSDK = $True
    }

		#Install Microsoft Azure Service Fabric Tools for Visual Studio 2015
		cChocoPackageInstaller MIcrosoftAzure-ServiceFabric-VS2015
		{
			Ensure = "Present"
			Name = "MIcrosoftAzure-ServiceFabric-VS2015"
            AutoUpgrade = $True
            chocoParams = "-source webpi"
		}

    # Reboot if pending
    xPendingReboot RebootCheck4
    {
    Name = "RebootCheck4"
    SkipPendingFileRename = $True
    SkipCcmClientSDK = $True
    }


		# Install Microsoft Azure Data Lake Tools for Visual Studio 2015
		cChocoPackageInstaller Vs2015AzurePack
		{
			Ensure = "Present"
			Name = "Vs2015AzurePack"
            AutoUpgrade = $True
            chocoParams = "-source webpi"
		}


    # Reboot if pending
    xPendingReboot RebootCheck5
    {
    Name = "RebootCheck5"
    SkipPendingFileRename = $True
    SkipCcmClientSDK = $True
    }

		#Install Microsoft Azure Tools for Microsoft Visual Studio 2015 - v2.9
		cChocoPackageInstaller VS2015CommunityAzurePack
		{
			Ensure = "Present"
			Name = "VS2015CommunityAzurePack"
            AutoUpgrade = $True
            chocoParams = "-source webpi"
		}

    # Reboot if pending
    xPendingReboot RebootCheck6
    {
    Name = "RebootCheck6"
    SkipPendingFileRename = $True
    SkipCcmClientSDK = $True
    }

		#Install Microsoft Visual Studio Community 2015 with Updates
		cChocoPackageInstaller VWDOrVs2015AzurePack
		{
			Ensure = "Present"
			Name = "VWDOrVs2015AzurePack"
            AutoUpgrade = $True
            chocoParams = "-source webpi"
		}

    # Reboot if pending
    xPendingReboot RebootCheck8
    {
    Name = "RebootCheck8"
    SkipPendingFileRename = $True
    SkipCcmClientSDK = $True
    }


		#Install Microsoft Azure PowerShell
		cChocoPackageInstaller WindowsAzurePowershellGet
		{
			Ensure = "Present"
			Name = "WindowsAzurePowershellGet"
            AutoUpgrade = $True
            chocoParams = "-source webpi"
		}

    # Reboot if pending
    xPendingReboot FinalRebootCheck
    {
    Name = "FinalRebootCheck"
    SkipPendingFileRename = $True
    SkipCcmClientSDK = $True
    }

<#

cChocoPackageInstaller installVS2015
{
Name        = "visualstudio2015community"
DependsOn   = "[cChocoInstaller]installChoco"
#This will automatically try to upgrade if available, only if a version is not explicitly specified. 
AutoUpgrade = $True
chocoParams = "--execution-timeout=9000"
Params = "Put in Admin XML File!"
}
#>




} 
}
AzureAdminWorkstation

Start-DscConfiguration .\AzureAdminWorkstation -wait -Verbose -force