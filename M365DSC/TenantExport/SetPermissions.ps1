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
$thumbprint = ''
# Test if cer file is present
if (Test-Path $CONFIG.CertificateCerPath) {
  #if so, test if is in the local storage
  $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $CONFIG.CertificateCerPath
  $thumbprint = $cert.Thumbprint

  $storeCert = Get-ChildItem 'Cert:\LocalMachine\My' | Where-Object Thumbprint -EQ $thumbprint
  if ($null -eq $storeCert) {
    Throw "A cer file is present, however the corresponding private key was not found in the local certificate store. `
    Please import it or delete de cer file $($CONFIG.CertificateCerPath) and try again."
  }
}

else {
  Write-Host 'No certificate found. Creating self-signed cert....'
  $cert = New-SelfSignedCertificate -Subject "cn=$($CONFIG.ApplicationName)_auth" `
    -CertStoreLocation 'Cert:\LocalMachine\My' `
    -NotAfter (Get-Date).AddYears(1) `
    -KeySpec KeyExchange

  $cert | Export-Certificate -Type cer -FilePath $CONFIG.CertificateCerPath -Force 
  $thumbprint = $cert.Thumbprint
}

Write-Host 'Updating permissions...'
Update-M365DSCAzureAdApplication -ApplicationName $CONFIG.ApplicationName `
  -Permissions $permsToApply `
  -AdminConsent `
  -CertificatePath $CONFIG.CertificateCerPath `
  -Type Certificate

Write-Host "App ID: $((Get-AzADApplication -DisplayName $CONFIG.ApplicationName).AppId)" 