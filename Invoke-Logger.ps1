Function Invoke-Logger {
    [cmdletbinding(DefaultParameterSetName="Information")]
    param(
        [Parameter(Mandatory=$True,ParameterSetName="Information",Position=0)]
        [string]$Info,

        [Parameter(Mandatory=$True,ParameterSetName="Warning",Position=0)]
        [string]$Warn,

        [Parameter(Mandatory=$True,ParameterSetName="Error",Position=0)]
        [string]$Err,

        [Parameter(Mandatory=$False)]
        [string]$Source = $MyInvocation.ScriptName,

        [Parameter(Mandatory=$False)]
        [string]$Delimiter = "`t",

        [Parameter(Mandatory=$False)]
        [switch]$FullName,

        [Parameter(Mandatory=$False)]
        [switch]$Silent,

        [parameter(Mandatory=$False)]
        [string]$LogFile = $Global:LogFile,

        [parameter(Mandatory=$False)]
        [ValidateSet("unicode", "utf7", "utf8", "utf32", "ascii", "bigendianunicode", "default", "oem")]
        [string]$Encoding = "default"
    )
    if ($LogFile -eq $null) { throw "Specify output logfile path in the `$Global:LogFile" }
    if (-not (Test-Path $LogFile)) { throw "Specify output logfile path in the `$Global:LogFile" }

    if (-not $FullName) { $Source = Split-Path -Leaf $Source }

    $datetime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    if ($Info) { $Message = $datetime,"Information",$Source,$Info -join $Delimiter; if (-not $Silent) { Write-Output  $Message } }
    if ($Warn) { $Message = $datetime,"Warning",    $Source,$Warn -join $Delimiter; if (-not $Silent) { Write-Warning $Message } }
    if ($Err)  { $Message = $datetime,"Error",      $Source,$Err  -join $Delimiter; if (-not $Silent) { Write-Error   $Message -ErrorAction "Continue" } }
    Write-Output $Message | Out-File -Append -Encoding $Encoding -FilePath $LogFile
}
Set-Alias -Name logger -Value Invoke-Logger
