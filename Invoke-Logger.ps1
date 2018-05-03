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
        [string]$Source = $MyInvocation.ScriptName
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
        if ($Global:LoggerActionPreference) {
            $config = $Global:LoggerActionPreference
            if ($config.File          ) { $Action         = { $_ | Out-File -Append $config.File; return $_ } }
            if ($config.Action        ) { $Action         = $config.Action }
            if ($config.LogFormat     ) { $LogFormat      = $config.LogFormat }
            if ($config.DateTimeFormat) { $DateTimeFormat = $config.DateTimeFormat }
            if ($config.Delimiter     ) { $Delimiter      = $config.Delimiter }
            if ($config.FullName      ) { $FullName       = $config.FullName }
        }
        $DateTime = Get-Date -Format $DateTimeFormat
        if ($Source -and -not $FullName) { $Source = Split-Path -Leaf $Source }
        if (-not $Source) { $Source = "Console" }
        $buf = New-Object System.Text.StringBuilder
    }
    process {
        foreach($m in $Messages) {
            $buf.AppendLine($m) > $null
        }
    }
    end {
        # Build Message
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
