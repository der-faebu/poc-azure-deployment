[CmdletBinding()]
param(
  [Parameter()]
  [ValidateSet('Teams', 'AADUser', 'AADGroup', 'SharePoint', 'Exchange', 'OneDrive', 'O365')]
  [array]$Resources
)

Import-Module Microsoft365DSC -Force
$env:CONFIG = & "$PSScriptRoot\TenantConfig.ps1"
$globalResources = $env:CONFIG.Resources
if ($null -eq $Resources) {
  $Resources = $env:CONFIG.Resources.GetEnumerator().Name
}
Connect-MicrosoftTeams -TenantId $env:CONFIG.TenantId `
  -ApplicationId $env:CONFIG.ApplicationId `
  -CertificateThumbprint $env:CONFIG.CertificateThumbprint

foreach ($resource in $Resources) {
  # Write-Host "Exporting resource $($resource):"
  # Write-Host "Components: $($globalResources[$resource])"
  Export-M365DSCConfiguration -Components $globalResources[$resource] `
    -Path $env:CONFIG.ExportDirectory `
    -FileName "$($resource).ps1" `
    -ApplicationId $env:CONFIG.ApplicationId  `
    -CertificateThumbprint $env:CONFIG.CertificateThumbprint `
    -TenantId $env:CONFIG.TenantId
}
