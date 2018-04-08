# Invoke-Logger

```ps1
# load ps1 file
. .\Invoke-Logger.ps1

# create logfile and set variable
$Global:LogFile = New-Item "D:\logs\message.txt" -type file

# Hello
logger -Info "Hello logger!"
````
