function Expand-Config {
  # [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [object]$InputObject, 
    ## Key / value pairs to replace placeholders. Defaults to the InputObject itself
    [Parameter(Mandatory = $false, Position = 1)]
    [hashtable]$Replacables
  )
  if (-not $Replacables) { 
    $Replacables = @{} 
  }
  if ($InputObject -is [System.Collections.Hashtable] -or $InputObject -is [System.Collections.Specialized.OrderedDictionary]) {
    $InputObject.Keys | Where-Object { 
      $InputObject[$_] -is [string] 
    } | ForEach-Object { $Replacables[$_] = $InputObject[$_] }
    @($InputObject.GetEnumerator()) | ForEach-Object {
      $key = $_.Key
      if ($InputObject[$key] -is [string]) {
        $Replacables.Keys | ForEach-Object { if ($InputObject[$key] -like "*<$_>*") {
            Write-Verbose "Replacing $($InputObject[$key]) with $($Replacables[$_])"
            $InputObject[$key] = $InputObject[$key].Replace("<$_>", $Replacables[$_]) 
          } 
        }
        $Replacables[$key] = $InputObject[$key]
      }
      else {
        Expand-Config -InputObject $InputObject[$key] -Replacables $Replacables.Clone()
      }
    }
  }
  elseif ($InputObject -is [array]) {
    $InputObject | ForEach-Object { Expand-Config $_ $Replacables.Clone() }
  }
}
