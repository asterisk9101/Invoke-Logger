Function Invoke-Logger {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$True,Position=1,ParameterSetName="Information")]
        [switch]$Info,

        [Parameter(Mandatory=$True,Position=1,ParameterSetName="Warning")]
        [switch]$Warn,

        [Parameter(Mandatory=$True,Position=1,ParameterSetName="Error")]
        [switch]$Err,

        [Parameter(Mandatory=$True,Position=2,ValueFromPipeline=$True)]
        [string[]]$Messages,
        
        [Parameter(Mandatory=$False,Position=3)]
        [string]$Source = $MyInvocation.ScriptName,

        [Parameter(Mandatory=$False,Position=4)]
        [Object]$Config = $Global:LoggerActionPreference
    )
    begin {
        # Default Parameter
        $LogFormat = {
            param($DateTime, $Source, $Level, $Message, $Delimiter)
            $DateTime, $Env:ComputerName, $Env:UserName, $Source, $Level, $Message -join $Delimiter
        }
        $DateTimeFormat = "yyyy-MM-dd HH:mm:ss.fff"
        $Delimiter = "`t"
        $FullName = $False
        $Action = { Write-Output $_ }

        # Preference Parameter
        if ($Config) {
            if ($Config.File          ) { $Action         = { $_ | Out-File -Append $Config.File; return $_ } }
            if ($Config.Action        ) { $Action         = $Config.Action }
            if ($Config.LogFormat     ) { $LogFormat      = $Config.LogFormat }
            if ($Config.DateTimeFormat) { $DateTimeFormat = $Config.DateTimeFormat }
            if ($Config.Delimiter     ) { $Delimiter      = $Config.Delimiter }
            if ($Config.FullName      ) { $FullName       = $Config.FullName }
        }
        $buf = New-Object System.Text.StringBuilder
    }
    process {
        foreach($m in $Messages) {
            $buf.AppendLine($m) > $null
        }
    }
    end {
        # Build Message
        $DateTime = Get-Date -Format $DateTimeFormat
        if ($Source -and -not $FullName) { $Source = Split-Path -Leaf $Source }
        if (-not $Source) { $Source = "Console" }
        if ($Info) { $Level = "Info" }
        if ($Warn) { $Level = "Warn" }
        if ($Err)  { $Level = "Error" }
        $Message = $buf.ToString() -replace '[\r\n]',' '
        $Log = & $LogFormat -DateTime $DateTime -Source $Source -Level $Level -Message $Message -Delimiter $Delimiter

        # Logging Action
        $Log | ForEach-Object $Action
    }
}
Set-Alias -Name logger -Value Invoke-Logger
