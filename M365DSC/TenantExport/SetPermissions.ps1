Import-Module Microsoft365DSC -Force
$CONFIG = & "$PSScriptRoot\TenantConfig.ps1"
Write-Output $CONFIG

az login --identity

$permsToApply = @()
$necessaryPermissions = @()

foreach ($resource in $CONFIG.Resources.GetEnumerator()) {
  $necessaryPermissions += $resource.Value
}

$totalPermissions = (Get-M365DSCCompiledPermissionList -ResourceNameList $necessaryPermissions).Read

foreach ($perm in $totalPermissions) {
  $permObj = @{
    Api            = $perm.Api
    PermissionName = $perm.Permission.Name
  }
  $permsToApply += $permObj
}
$thumbprint = (Invoke-Command {az keyvault certificate list --vault-name mcr5edeployment --output json | ConvertFrom-Json}).x509ThumbprintHex

Write-Host 'Updating permissions...'
Update-M365DSCAzureAdApplication -ApplicationName $CONFIG.ApplicationName `
  -Permissions $permsToApply `
  -AdminConsent

Write-Host "App ID: $((Get-AzADApplication -DisplayName $CONFIG.ApplicationName).AppId)" 