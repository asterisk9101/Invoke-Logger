$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Invoke-Logger" {
    Context "基本的な機能" {
        It "Information レベルのメッセージが出力される" {
            Invoke-Logger -Info "Message" | Should -Match "Message"
        }
        It "Warning レベルのメッセージが出力される" {
            Invoke-Logger -Warn "Message" | Should -Match "Message"
        }
        It "Error レベルのメッセージが出力される" {
            Invoke-Logger -Err "Message" | Should -Match "Message"
        }
        It "Source が指定できる" {
            Invoke-Logger -Info "Message" -Source "Logger" | Should -Match "Logger"
        }
        It "logger エイリアスが使える" {
            logger -Info "Message" | Should -Match "Message"
        }
    }
}