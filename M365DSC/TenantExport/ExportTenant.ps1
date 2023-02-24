[CmdletBinding()]
param(
  [Parameter()]
  [ValidateSet('Teams', 'AADUser', 'AADGroup', 'SharePoint', 'Exchange', 'OneDrive', 'O365')]
  [array]$Resources
)

Import-Module Microsoft365DSC -Force
$CONFIG = & "$PSScriptRoot\TenantConfig.ps1"
$globalResources = $CONFIG.Resources
if ($null -eq $Resources) {
  $Resources = $CONFIG.Resources.GetEnumerator().Name
}
Connect-MicrosoftTeams -TenantId $CONFIG.TenantId `
  -ApplicationId $CONFIG.ApplicationId `
  -CertificateThumbprint $CONFIG.CertificateThumbprint

foreach ($resource in $Resources) {
  # Write-Host "Exporting resource $($resource):"
  # Write-Host "Components: $($globalResources[$resource])"
  Export-M365DSCConfiguration -Components $globalResources[$resource] `
    -Path $CONFIG.ExportDirectory `
    -FileName "$($resource).ps1" `
    -ApplicationId $CONFIG.ApplicationId  `
    -CertificateThumbprint $CONFIG.CertificateThumbprint `
    -TenantId $CONFIG.TenantId
}
