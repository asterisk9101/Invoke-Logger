Function Invoke-Logger {
    [cmdletbinding(DefaultParameterSetName="Information")]
    param(
        [Parameter(Mandatory=$True,ParameterSetName="Information")]
        [string]$Info,

        [Parameter(Mandatory=$True,ParameterSetName="Warning")]
        [string]$Warn,

        [Parameter(Mandatory=$True,ParameterSetName="Error")]
        [string]$Err,

        [Parameter(Mandatory=$False)]
        [string]$Source = $MyInvocation.ScriptName
    )
    # Default Parameter
    $LogFormat = {
        param($DateTime, $Source, $Level, $Message, $Delimiter)
        $DateTime, $Env:ComputerName, $Env:UserName, $Source, $Level, $Message -join $Delimiter
    }
    $DateTimeFormat = "yyyy-MM-dd HH:mm:ss"
    $Delimiter = "`t"
    $FullName = $False
    $Action = { Write-Output $_ }

    # Preference Parameter
    if ($Global:LoggerActionPreference) {
        $config = $Global:LoggerActionPreference
        if ($config.File          ) { $Action         = { $_ | Out-File -Append $config.File } }
        if ($config.Action        ) { $Action         = $config.Action }
        if ($config.LogFormat     ) { $LogFormat      = $config.LogFormat }
        if ($config.DateTimeFormat) { $DateTimeFormat = $config.DateTimeFormat }
        if ($config.Delimiter     ) { $Delimiter      = $config.Delimiter }
        if ($config.FullName      ) { $FullName       = $config.FullName }
    }

    # Build Message
    $DateTime = Get-Date -Format $DateTimeFormat
    if ($Source -and -not $FullName) { $Source = Split-Path -Leaf $Source }
    if (-not $Source) { $Source = "Console" }
    if ($Info) { $Level = "Info"; $Message = $Info }
    if ($Warn) { $Level = "Warn"; $Message = $Warn }
    if ($Err)  { $Level = "Error"; $Message = $Err }
    $Log = & $LogFormat -DateTime $DateTime -Source $Source -Level $Level -Message $Message -Delimiter $Delimiter

    # Logging Action
    $Log | ForEach-Object $Action
}
Set-Alias -Name logger -Value Invoke-Logger
