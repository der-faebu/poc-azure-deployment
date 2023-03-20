Write-Host 'Importing helper functions'
. "$PSScriptRoot\helpers.ps1"

$settings = [ordered]@{
  CustomerName          = $env:CUSTOMER_NAME
  CustomerId            = $env:CUSTOMER_ID
  ApplicationName       = $env:APPLICATION_NAME
  TenantId              = $env:TENANT_ID # cannot be a guid
  # will only be known after running SetPermissions
  ApplicationId         = $env:APPLICATION_ID
  CertificateThumbprint = $env:CERTIFICATE_THUMBPRINT
  CertificatePfxPath    = "$PSScriptRoot\certificates\<CustomerId>_m365dsc_sp.pfx"
  CertificateCerPath    = "$PSScriptRoot\certificates\<CustomerId>_m365dsc_sp.cer"
  Resources             = @{
    AADUser    = @('AADUser')
    AADTenant  = @('AADTenantDetails')
    AADGroup   = @('AADGroup', 'AADGroupsSettings')
    O365       = @('O365AdminAuditLogConfig', 'O365Group', 'O365OrgCustomizationSetting', 'O365OrgSettings')
    OneDrive   = @('ODSettings')
    SharePoint = @('SPOAccessControlSettings', 'SPOApp', 'SPOBrowserIdleSignout', 'SPOHomeSite', 'SPOHubSite', 'SPOOrgAssetsLibrary',
      'SPOPropertyBag', 'SPOSearchManagedProperty', 'SPOSearchResultSource', 'SPOSharingSettings', 'SPOSite', 'SPOSiteAuditSettings', 
      'SPOSiteDesign', 'SPOSiteDesignRights', 'SPOSiteGroup', 'SPOSiteScript', 'SPOStorageEntity', 'SPOTenantCdnEnabled', 'SPOTenantCdnPolicy',
      'SPOTenantSettings', 'SPOTheme', 'SPOUserProfileProperty')
    Teams      = @('TeamsAudioConferencingPolicy', 'TeamsCallHoldPolicy', 'TeamsCallingPolicy', 'TeamsCallParkPolicy', 'TeamsChannel', 
      'TeamsChannelsPolicy', 'TeamsChannelTab', 'TeamsClientConfiguration', 'TeamsComplianceRecordingPolicy', 'TeamsCortanaPolicy',
      'TeamsDialInConferencingTenantSettings', 'TeamsEmergencyCallingPolicy', 'TeamsEmergencyCallRoutingPolicy', 
      'TeamsEnhancedEncryptionPolicy', 'TeamsEventsPolicy', 'TeamsFederationConfiguration', 'TeamsFeedbackPolicy', 
      'TeamsFilesPolicy', 'TeamsGroupPolicyAssignment', 'TeamsGuestCallingConfiguration', 'TeamsGuestMeetingConfiguration', 
      'TeamsGuestMessagingConfiguration', 'TeamsIPPhonePolicy', 'TeamsMeetingBroadcastConfiguration', 'TeamsMeetingBroadcastPolicy',
      'TeamsMeetingConfiguration', 'TeamsMeetingPolicy', 'TeamsMessagingPolicy', 'TeamsMobilityPolicy', 'TeamsNetworkRoamingPolicy', 
      'TeamsOnlineVoicemailPolicy', 'TeamsOnlineVoicemailUserSettings', 'TeamsOnlineVoiceUser', 'TeamsPstnUsage', 'TeamsShiftsPolicy', 
      'TeamsTeam', 'TeamsTenantDialPlan', 'TeamsTenantNetworkRegion', 'TeamsTenantNetworkSite', 'TeamsTenantNetworkSubnet', 
      'TeamsTenantTrustedIPAddress', 'TeamsTranslationRule', 'TeamsUnassignedNumberTreatment', 'TeamsUpdateManagementPolicy', 
      'TeamsUpgradeConfiguration', 'TeamsUpgradePolicy', 'TeamsUser', 'TeamsUserCallingSettings', 'TeamsVdiPolicy', 'TeamsVoiceRoute',
      'TeamsVoiceRoutingPolicy', 'TeamsWorkloadPolicy') 
  }
  ExportDirectory       = 'C:\tmp\DSC_Export\<CustomerId>'

  ## todo: install or update all required modules
  RequiredModules = @(
    'Az.Resources'
  )
}
Write-Host 'Expanding Settings'
Expand-Config -InputObject $settings
Write-Output $settings