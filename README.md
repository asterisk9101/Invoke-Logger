# Invoke-Logger

load ps1

```ps1
. .\Invoke-Logger.ps1
. .\New-LoggerConfig.ps1
```


## Basic usage

```ps1
# Set Logger Configuration(specify output file)
$Global:LoggerActionPreference = New-LoggerConfig -File Log.txt

# available alias
logger -Info "Hello logger!"
```

## Advanced usage

```ps1
# Logger Configuration
$Global:LoggerActionPreference = New-LoggerConfig `
    -Action {
        # tee -a Log.txt
        Write-Output $_
        $_ | Out-File -Append Log.txt
    } `
    -DateTimeFormat "yyyy/MM/dd" `
    -Delimiter "," `
    -LogFormat {
        param($DateTime, $Source, $Level, $Message, $Delimiter)
        if ($Level -eq "Info") { $Level = "😁" }
        if ($Level -eq "Warn") { $Level = "😅" }
        if ($Level -eq "Error"){ $Level = "😱" }
        $DateTime, "?", $Level, $Message -join $Delimiter
        # => 2018-04-01,❤,😱,Advanced Hello Logger!
    }

logger -Err "Advanced Hello logger!"
```
