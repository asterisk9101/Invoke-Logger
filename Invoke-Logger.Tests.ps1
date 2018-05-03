$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Invoke-Logger" {
    Context "基本的な機能" {
        It "Information レベルのメッセージが出力される" {
            Invoke-Logger -Info "Message" | Should -Match "Info"
        }
        It "Warning レベルのメッセージが出力される" {
            Invoke-Logger -Warn "Message" | Should -Match "Warn"
        }
        It "Error レベルのメッセージが出力される" {
            Invoke-Logger -Err "Message" | Should -Match "Error"
        }
        It "Source の既定値のスクリプト名が出力される" {
            Invoke-Logger -Info "Message" | Should -Match "Invoke-Logger.Tests.ps1"
        }
        It "Source が指定できる" {
            Invoke-Logger -Info "Message" -Source "Logger" | Should -Match "Logger"
        }
        It "logger エイリアスが使える" {
            logger -Info "Message" | Should -Match "Message"
        }
        It "パイプライン入力ができる" {
            Write-Output "Message" | logger -Info | Should -Match "Message"
        }
        It "複数の入力を1行に集約して出力する" {
            $Messages = Write-Output "Message1", "Message2`r`nMessage3" | logger -info
            $Messages | % { $_ -split '[\r\n]' } | Measure-Object | Select-Object -ExpandProperty count | Should -Be 1
        }
    }
    Context "エラー処理" {
        It "レベルが指定されていない場合はエラーになる" {
            { logger "hoge" } | Should -Throw
        }
    }
}