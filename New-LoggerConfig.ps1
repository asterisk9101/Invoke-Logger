Function New-LoggerConfig {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$False,ParameterSetName="File")]
        [String]$File,

        [Parameter(Mandatory=$False,ParameterSetName="Action")]
        [Scriptblock]$Action,

        [Parameter(Mandatory=$False)]
        [ScriptBlock]$LogFormat,

        [Parameter(Mandatory=$False)]
        [String]$DateTimeFormat,

        [Parameter(Mandatory=$False)]
        [String]$Delimiter,

        [Parameter(Mandatory=$False)]
        [switch]$FullName
    )
    $config = New-Object PSObject
    if ($File          ) { $config | Add-Member NoteProperty File $File }
    if ($Action        ) { $config | Add-Member NoteProperty Action $Action }
    if ($LogFormat     ) { $config | Add-Member NoteProperty LogFormat $LogFormat }
    if ($DateTimeFormat) { $config | Add-Member NoteProperty DateTimeFormat $DateTimeFormat }
    if ($Delimiter     ) { $config | Add-Member NoteProperty Delimiter $Delimiter }
    if ($FullName      ) { $config | Add-Member NoteProperty FullName $FullName }
    return $config
}
