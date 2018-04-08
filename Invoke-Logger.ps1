Function Invoke-Logger {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$True)]
        [ValidateSet("Information", "Warning", "Error")]
        [string]$Type,

        [Parameter(Mandatory=$True)]
        [ValidatePattern('^[^ ]*$')]
        [string]$Source,

        [Parameter(Mandatory=$True)]
        [string]$Message,

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

    $datetime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    switch($Type){
        "Information" {
            $Message = "$datetime Information $source $message"
            if (-not $silent) { Write-Output $Message }
            Write-Output $Message | Out-File -Append -Encoding $Encoding -FilePath $LogFile
        }
        "Warning" {
            $Message = "$datetime Warning     $source $message"
            if (-not $silent) { Write-Warning $Message }
            Write-Output $Message | Out-File -Append -Encoding $Encoding -FilePath $LogFile
        }
        "Error" {
            $Message = "$datetime Error       $source $message"
            if (-not $silent) { Write-Error $Message -ErrorAction "continue" }
            Write-Output $Message | Out-File -Append -Encoding $Encoding -FilePath $LogFile
        }
    }
}
Set-Alias -Name logger -Value Invoke-Logger
